import 'package:flutter/foundation.dart';

import '../../../domain/exceptions/auth_failure.dart';
import '../../../data/repositories/auth_repository.dart';

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
  ResetPasswordViewModel(this._authRepository);

  final AuthRepository _authRepository;

  String _email = '';
  bool _isSubmitting = false;

  String get email => _email;

  bool get isSubmitting => _isSubmitting;

  bool get canSubmit {
    return _email.trim().isNotEmpty && !_isSubmitting;
  }

  /// Aggiorna l'email corrente normalizzando il valore inserito dalla View.
  void updateEmail(String value) {
    final normalizedEmail = value.trim();

    if (_email == normalizedEmail) {
      return;
    }

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
      await _authRepository.sendPasswordResetEmail(email: _email);

      return ResetPasswordSubmitResult.success(
        'Se l’email è associata a un account JiVaio, riceverai un link per reimpostare la password.',
      );
    } on AuthFailure catch (error) {
      return ResetPasswordSubmitResult.failure(_mapAuthFailure(error.code));
    } catch (_) {
      return const ResetPasswordSubmitResult.failure(
        'Si è verificato un errore imprevisto. Riprova.',
      );
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  bool _isValidEmail(String value) {
    final email = value.trim();
    return email.contains('@') && email.contains('.');
  }

  String _mapAuthFailure(AuthFailureCode code) {
    switch (code) {
      case AuthFailureCode.invalidEmail:
        return 'Inserisci un indirizzo email valido.';
      case AuthFailureCode.networkRequestFailed:
        return 'Controlla la connessione e riprova.';
      case AuthFailureCode.tooManyRequests:
        return 'Troppe richieste in poco tempo. Riprova più tardi.';
      case AuthFailureCode.userNotFound:
        return 'Se l’email è associata a un account JiVaio, riceverai un link per reimpostare la password.';
      case AuthFailureCode.wrongPassword:
      case AuthFailureCode.emailAlreadyInUse:
      case AuthFailureCode.weakPassword:
      case AuthFailureCode.invalidCredential:
      case AuthFailureCode.userDisabled:
      case AuthFailureCode.operationNotAllowed:
      case AuthFailureCode.unknown:
        return 'Non è stato possibile inviare il link di recupero. Riprova.';
    }
  }
}
