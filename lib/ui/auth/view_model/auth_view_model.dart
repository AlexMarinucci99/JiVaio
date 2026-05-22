import 'package:flutter/foundation.dart';

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
  AuthMode _selectedMode = AuthMode.login;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  AuthMode get selectedMode => _selectedMode;

  bool get obscurePassword => _obscurePassword;

  bool get obscureConfirmPassword => _obscureConfirmPassword;

  bool get isLogin => _selectedMode == AuthMode.login;

  String get primaryButtonText {
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
    if (_selectedMode == mode) {
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
    if (email.isEmpty || password.isEmpty) {
      return const AuthSubmitResult.invalid('Inserisci email e password');
    }

    return const AuthSubmitResult.valid();
  }

  AuthSubmitResult _validateRegister({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) {
    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      return const AuthSubmitResult.invalid('Compila tutti i campi');
    }

    if (password != confirmPassword) {
      return const AuthSubmitResult.invalid('Le password non coincidono');
    }

    return const AuthSubmitResult.valid();
  }
}