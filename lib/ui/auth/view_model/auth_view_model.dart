import 'package:flutter/foundation.dart';

import '../../../data/repositories/auth_repository.dart';
import '../../../domain/exceptions/auth_failure.dart';

/// Modalità disponibili nel form di autenticazione.
enum AuthMode { login, register }

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
  Future<String?> submit({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    final validationMessage = _validateSubmit(
      name: name,
      email: email,
      password: password,
      confirmPassword: confirmPassword,
    );

    if (validationMessage != null) return validationMessage;

    return _runSubmission(
      () => isLogin
          ? _repository.login(email: email, password: password)
          : _repository.register(name: name, email: email, password: password),
      unexpectedError: 'Si è verificato un errore imprevisto. Riprova.',
    );
  }

  /// Esegue l'accesso tramite account Google.
  Future<String?> signInWithGoogle() => _runSubmission(
    _repository.loginWithGoogle,
    unexpectedError: 'Accesso con Google non riuscito. Riprova.',
  );

  /// Esegue una richiesta auth gestendo caricamento ed errori comuni.
  Future<String?> _runSubmission(
    Future<void> Function() action, {
    required String unexpectedError,
  }) async {
    if (_isSubmitting) {
      return 'Attendi il completamento dell’operazione in corso.';
    }

    _isSubmitting = true;
    notifyListeners();

    try {
      await action();
      return null;
    } on AuthFailure catch (error) {
      return _mapAuthFailure(error.code);
    } catch (_) {
      return unexpectedError;
    } finally {
      _isSubmitting = false;
      if (hasListeners) notifyListeners();
    }
  }

  /// Valida i dati richiesti dalla modalità auth corrente.
  String? _validateSubmit({
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

  String? _validateLogin({required String email, required String password}) {
    if (email.trim().isEmpty || password.isEmpty) {
      return 'Inserisci email e password';
    }

    if (!_isValidEmail(email)) {
      return 'Inserisci un indirizzo email valido';
    }

    return null;
  }

  String? _validateRegister({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) {
    if (name.trim().isEmpty ||
        email.trim().isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      return 'Compila tutti i campi';
    }

    if (!_isValidEmail(email)) {
      return 'Inserisci un indirizzo email valido';
    }

    if (password.length < 6) {
      return 'La password deve contenere almeno 6 caratteri';
    }

    if (password != confirmPassword) {
      return 'Le password non coincidono';
    }

    return null;
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
