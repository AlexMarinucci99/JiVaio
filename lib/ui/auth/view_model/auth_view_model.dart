import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../../../data/repositories/auth_repository.dart';

enum AuthMode { login, register }

class AuthSubmitResult {
  const AuthSubmitResult._({
    required this.isValid,
    this.message,
  });

  final bool isValid;
  final String? message;

  const AuthSubmitResult.valid() : this._(isValid: true);

  const AuthSubmitResult.invalid(String message)
    : this._(isValid: false, message: message);
}

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

  void setMode(AuthMode mode) {
    if (_selectedMode == mode || _isSubmitting) {
      return;
    }

    _selectedMode = mode;
    notifyListeners();
  }

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    _obscureConfirmPassword = !_obscureConfirmPassword;
    notifyListeners();
  }

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
        await _authRepository.login(
          email: email,
          password: password,
        );
      } else {
        await _authRepository.register(
          name: name,
          email: email,
          password: password,
        );
      }

      return const AuthSubmitResult.valid();
    } on FirebaseAuthException catch (error) {
      return AuthSubmitResult.invalid(
        _mapFirebaseAuthError(error.code),
      );
    } catch (_) {
      return const AuthSubmitResult.invalid(
        'Si è verificato un errore imprevisto. Riprova.',
      );
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  AuthSubmitResult validateSubmit({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) {
    if (isLogin) {
      return _validateLogin(
        email: email,
        password: password,
      );
    }

    return _validateRegister(
      name: name,
      email: email,
      password: password,
      confirmPassword: confirmPassword,
    );
  }

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
      return const AuthSubmitResult.invalid('Inserisci un indirizzo email valido');
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
      return const AuthSubmitResult.invalid('Inserisci un indirizzo email valido');
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

  String _mapFirebaseAuthError(String code) {
    switch (code) {
      case 'invalid-email':
        return 'Email non valida.';
      case 'user-not-found':
        return 'Nessun account trovato con questa email.';
      case 'wrong-password':
        return 'Password non corretta.';
      case 'email-already-in-use':
        return 'Questa email è già associata a un account.';
      case 'weak-password':
        return 'La password è troppo debole.';
      case 'network-request-failed':
        return 'Controlla la connessione e riprova.';
      case 'invalid-credential':
        return 'Credenziali non valide.';
      default:
        return 'Autenticazione non riuscita. Riprova.';
    }
  }
}