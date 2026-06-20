import 'package:flutter/foundation.dart';

import '../../../domain/exceptions/auth_failure.dart';
import '../../../data/repositories/auth_repository.dart';

/// Modalità disponibili nel form di autenticazione.
enum AuthMode { login, register }

/// Risultato prodotto dalla validazione o dall'invio del form auth.
class AuthSubmitResult {
  const AuthSubmitResult._({required this.isValid, this.message});

  final bool isValid;
  final String? message;

  /// Crea un risultato valido.
  const AuthSubmitResult.valid() : this._(isValid: true);

  /// Crea un risultato non valido con [message].
  const AuthSubmitResult.invalid(String message)
    : this._(isValid: false, message: message);
}

/// Gestisce stato, validazione e invio dei form di autenticazione.
///
/// Il ViewModel mantiene la logica fuori dalla View e comunica
/// con [AuthRepository] senza esporre dettagli del provider esterno.
class AuthViewModel extends ChangeNotifier {
  AuthViewModel(this._authRepository);

  final AuthRepository _authRepository;

  AuthMode _selectedMode = AuthMode.login;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isSubmitting = false;

  AuthMode get selectedMode => _selectedMode;

  bool get obscurePassword => _obscurePassword;

  bool get obscureConfirmPassword => _obscureConfirmPassword;

  bool get isSubmitting => _isSubmitting;

  bool get isLogin => _selectedMode == AuthMode.login;

  String get primaryButtonText {
    if (_isSubmitting) {
      return isLogin ? 'Accesso in corso...' : 'Registrazione in corso...';
    }

    return isLogin ? 'Accedi' : 'Registrati';
  }

  String get formTitle {
    return isLogin ? 'Bentornato' : 'Crea account';
  }

  String get formSubtitle {
    return isLogin
        ? 'Accedi per salvare linee e ricevere notifiche.'
        : 'Registrati per personalizzare la tua esperienza.';
  }

  /// Cambia la modalità del form tra login e registrazione.
  void setMode(AuthMode mode) {
    if (_selectedMode == mode || _isSubmitting) {
      return;
    }

    _selectedMode = mode;
    notifyListeners();
  }

  /// Alterna la visibilità della password.
  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  /// Alterna la visibilità del campo conferma password.
  void toggleConfirmPasswordVisibility() {
    _obscureConfirmPassword = !_obscureConfirmPassword;
    notifyListeners();
  }

  /// Valida i dati del form ed esegue login o registrazione.
  Future<AuthSubmitResult> submit({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    final validationResult = validateSubmit(
      name: name,
      email: email,
      password: password,
      confirmPassword: confirmPassword,
    );

    if (!validationResult.isValid) {
      return validationResult;
    }

    _isSubmitting = true;
    notifyListeners();

    try {
      if (isLogin) {
        await _authRepository.login(email: email, password: password);
      } else {
        await _authRepository.register(
          name: name,
          email: email,
          password: password,
        );
      }

      return const AuthSubmitResult.valid();
    } on AuthFailure catch (error) {
      return AuthSubmitResult.invalid(_mapAuthFailure(error.code));
    } catch (_) {
      return const AuthSubmitResult.invalid(
        'Si è verificato un errore imprevisto. Riprova.',
      );
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  /// Valida i dati richiesti dalla modalità auth corrente.
  AuthSubmitResult validateSubmit({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) {
    if (isLogin) {
      return _validateLogin(email: email, password: password);
    }

    return _validateRegister(
      name: name,
      email: email,
      password: password,
      confirmPassword: confirmPassword,
    );
  }

  /// Restituisce il messaggio temporaneo per i provider social non implementati.
  String socialLoginMessage(String provider) {
    return 'Accesso con $provider non ancora implementato';
  }

  AuthSubmitResult _validateLogin({
    required String email,
    required String password,
  }) {
    if (email.trim().isEmpty || password.isEmpty) {
      return const AuthSubmitResult.invalid('Inserisci email e password');
    }

    if (!_isValidEmail(email)) {
      return const AuthSubmitResult.invalid(
        'Inserisci un indirizzo email valido',
      );
    }

    return const AuthSubmitResult.valid();
  }

  AuthSubmitResult _validateRegister({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) {
    if (name.trim().isEmpty ||
        email.trim().isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      return const AuthSubmitResult.invalid('Compila tutti i campi');
    }

    if (!_isValidEmail(email)) {
      return const AuthSubmitResult.invalid(
        'Inserisci un indirizzo email valido',
      );
    }

    if (password.length < 6) {
      return const AuthSubmitResult.invalid(
        'La password deve contenere almeno 6 caratteri',
      );
    }

    if (password != confirmPassword) {
      return const AuthSubmitResult.invalid('Le password non coincidono');
    }

    return const AuthSubmitResult.valid();
  }

  bool _isValidEmail(String value) {
    final email = value.trim();
    return email.contains('@') && email.contains('.');
  }

  String _mapAuthFailure(AuthFailureCode code) {
    switch (code) {
      case AuthFailureCode.invalidEmail:
        return 'Email non valida.';
      case AuthFailureCode.userNotFound:
        return 'Nessun account trovato con questa email.';
      case AuthFailureCode.wrongPassword:
        return 'Password non corretta.';
      case AuthFailureCode.emailAlreadyInUse:
        return 'Questa email è già associata a un account.';
      case AuthFailureCode.weakPassword:
        return 'La password è troppo debole.';
      case AuthFailureCode.networkRequestFailed:
        return 'Controlla la connessione e riprova.';
      case AuthFailureCode.invalidCredential:
        return 'Credenziali non valide.';
      case AuthFailureCode.tooManyRequests:
        return 'Troppe richieste in poco tempo. Riprova più tardi.';
      case AuthFailureCode.userDisabled:
        return 'Questo account è stato disabilitato.';
      case AuthFailureCode.operationNotAllowed:
        return 'Operazione non disponibile. Riprova più tardi.';
      case AuthFailureCode.unknown:
        return 'Autenticazione non riuscita. Riprova.';
    }
  }
}
