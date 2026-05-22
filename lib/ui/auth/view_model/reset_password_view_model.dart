import 'package:flutter/foundation.dart';

class ResetPasswordSubmitResult {
  const ResetPasswordSubmitResult._({
    required this.isSuccess,
    required this.message,
  });

  final bool isSuccess;
  final String message;

  const ResetPasswordSubmitResult.success(String message)
    : this._(isSuccess: true, message: message);

  const ResetPasswordSubmitResult.failure(String message)
    : this._(isSuccess: false, message: message);
}

class ResetPasswordViewModel extends ChangeNotifier {
  String _email = '';
  bool _isSubmitting = false;

  String get email => _email;

  bool get isSubmitting => _isSubmitting;

  bool get canSubmit {
    return _email.trim().isNotEmpty && !_isSubmitting;
  }

  void updateEmail(String value) {
    final normalizedEmail = value.trim();

    if (_email == normalizedEmail) {
      return;
    }

    _email = normalizedEmail;
    notifyListeners();
  }

  Future<ResetPasswordSubmitResult> sendResetLink() async {
    if (_email.isEmpty) {
      return const ResetPasswordSubmitResult.failure(
        'Inserisci la tua email',
      );
    }

    if (!_isValidEmail(_email)) {
      return const ResetPasswordSubmitResult.failure(
        'Inserisci un indirizzo email valido',
      );
    }

    _isSubmitting = true;
    notifyListeners();

    try {
      // Simulazione provvisoria.
      // Quando collegheremo Firebase, qui passeremo da AuthRepository.
      return ResetPasswordSubmitResult.success(
        'Link di recupero inviato a $_email',
      );
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  bool _isValidEmail(String value) {
    return value.contains('@') && value.contains('.');
  }
}