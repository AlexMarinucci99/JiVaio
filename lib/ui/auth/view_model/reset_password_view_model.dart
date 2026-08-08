import 'package:flutter/foundation.dart';

import '../../../data/repositories/auth_repository.dart';
import '../../../domain/exceptions/auth_failure.dart';

const String _safeResetPasswordMessage =
    'Se l’email è associata a un account JiVaio, riceverai un link per reimpostare la password.';

/// Risultato dell'invio del link di recupero password.
class ResetPasswordSubmitResult {
  const ResetPasswordSubmitResult._({
    required this.isSuccess,
    required this.message,
  });

  final bool isSuccess;
  final String message;

  /// Crea un risultato positivo con [message].
  const ResetPasswordSubmitResult.success(String message)
    : this._(isSuccess: true, message: message);

  /// Crea un risultato negativo con [message].
  const ResetPasswordSubmitResult.failure(String message)
    : this._(isSuccess: false, message: message);
}

/// Gestisce stato, validazione e invio del recupero password.
///
/// Il ViewModel mantiene la logica fuori dalla schermata e delega
/// l'operazione di recupero ad [AuthRepository].
class ResetPasswordViewModel extends ChangeNotifier {
  ResetPasswordViewModel(this._repository);

  final AuthRepository _repository;

  String _email = '';
  bool _isSubmitting = false;

  String get email => _email;

  bool get isSubmitting => _isSubmitting;

  bool get canSubmit => _email.isNotEmpty && !_isSubmitting;

  /// Aggiorna l'email corrente normalizzando il valore inserito dalla View.
  void updateEmail(String value) {
    final normalizedEmail = value.trim();

    if (_email == normalizedEmail) return;

    _email = normalizedEmail;
    notifyListeners();
  }

  /// Valida l'email e invia il link di recupero password.
  Future<ResetPasswordSubmitResult> sendResetLink() async {
    if (_email.isEmpty) {
      return const ResetPasswordSubmitResult.failure('Inserisci la tua email');
    }

    if (!_isValidEmail(_email)) {
      return const ResetPasswordSubmitResult.failure(
        'Inserisci un indirizzo email valido',
      );
    }

    _isSubmitting = true;
    notifyListeners();

    try {
      await _repository.sendPasswordResetEmail(email: _email);

      return const ResetPasswordSubmitResult.success(_safeResetPasswordMessage);
    } on AuthFailure catch (error) {
      return _mapAuthFailure(error.code);
    } catch (_) {
      return const ResetPasswordSubmitResult.failure(
        'Si è verificato un errore imprevisto. Riprova.',
      );
    } finally {
      _isSubmitting = false;
      if (hasListeners) notifyListeners();
    }
  }

  bool _isValidEmail(String value) =>
      value.contains('@') && value.contains('.');

  ResetPasswordSubmitResult _mapAuthFailure(AuthFailureCode code) =>
      switch (code) {
        AuthFailureCode.invalidEmail => const ResetPasswordSubmitResult.failure(
          'Inserisci un indirizzo email valido.',
        ),
        AuthFailureCode.networkRequestFailed =>
          const ResetPasswordSubmitResult.failure(
            'Controlla la connessione e riprova.',
          ),
        AuthFailureCode.tooManyRequests =>
          const ResetPasswordSubmitResult.failure(
            'Troppe richieste in poco tempo. Riprova più tardi.',
          ),
        AuthFailureCode.userNotFound => const ResetPasswordSubmitResult.success(
          _safeResetPasswordMessage,
        ),
        _ => const ResetPasswordSubmitResult.failure(
          'Non è stato possibile inviare il link di recupero. Riprova.',
        ),
      };
}
