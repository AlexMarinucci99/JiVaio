import 'package:flutter/foundation.dart';

import '../../../data/repositories/auth_repository.dart';
import '../../../domain/exceptions/auth_failure.dart';

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
  AuthViewModel(this._repository);

  final AuthRepository _repository;

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

  String get formTitle => isLogin ? 'Bentornato' : 'Crea account';

  String get formSubtitle => isLogin
      ? 'Accedi per salvare linee e ricevere notifiche.'
      : 'Registrati per personalizzare la tua esperienza.';

  /// Cambia la modalità del form tra login e registrazione.
  void setMode(AuthMode mode) {
    if (_selectedMode == mode || _isSubmitting) return;

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

    if (!validationResult.isValid) return validationResult;

    return _runSubmission(
      () => isLogin
          ? _repository.login(email: email, password: password)
          : _repository.register(name: name, email: email, password: password),
      unexpectedError: 'Si è verificato un errore imprevisto. Riprova.',
    );
  }

  /// Esegue l'accesso tramite account Google.
  Future<AuthSubmitResult> signInWithGoogle() => _runSubmission(
    _repository.loginWithGoogle,
    unexpectedError: 'Accesso con Google non riuscito. Riprova.',
  );

  /// Esegue una richiesta auth gestendo caricamento ed errori comuni.
  Future<AuthSubmitResult> _runSubmission(
    Future<void> Function() action, {
    required String unexpectedError,
  }) async {
    if (_isSubmitting) {
      return const AuthSubmitResult.invalid(
        'Attendi il completamento dell’operazione in corso.',
      );
    }

    _isSubmitting = true;
    notifyListeners();

    try {
      await action();
      return const AuthSubmitResult.valid();
    } on AuthFailure catch (error) {
      return AuthSubmitResult.invalid(_mapAuthFailure(error.code));
    } catch (_) {
      return AuthSubmitResult.invalid(unexpectedError);
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
  }) => isLogin
      ? _validateLogin(email: email, password: password)
      : _validateRegister(
          name: name,
          email: email,
          password: password,
          confirmPassword: confirmPassword,
        );

  /// Restituisce il messaggio temporaneo per i provider social non implementati.
  String socialLoginMessage(String provider) =>
      'Accesso con $provider non ancora implementato';

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

  bool _isValidEmail(String value) =>
      value.contains('@') && value.contains('.');

  String _mapAuthFailure(AuthFailureCode code) => switch (code) {
    AuthFailureCode.invalidEmail => 'Email non valida.',
    AuthFailureCode.userNotFound => 'Nessun account trovato con questa email.',
    AuthFailureCode.wrongPassword => 'Password non corretta.',
    AuthFailureCode.emailAlreadyInUse =>
      'Questa email è già associata a un account.',
    AuthFailureCode.weakPassword => 'La password è troppo debole.',
    AuthFailureCode.networkRequestFailed =>
      'Controlla la connessione e riprova.',
    AuthFailureCode.invalidCredential => 'Credenziali non valide.',
    AuthFailureCode.tooManyRequests =>
      'Troppe richieste in poco tempo. Riprova più tardi.',
    AuthFailureCode.userDisabled => 'Questo account è stato disabilitato.',
    AuthFailureCode.operationNotAllowed =>
      'Operazione non disponibile. Riprova più tardi.',
    AuthFailureCode.cancelled => 'Accesso con Google annullato.',
    AuthFailureCode.unknown => 'Autenticazione non riuscita. Riprova.',
  };
}
