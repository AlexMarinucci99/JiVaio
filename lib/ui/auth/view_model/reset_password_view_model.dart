import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../../../data/repositories/auth_repository.dart';

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
  ResetPasswordViewModel(this._authRepository);

  final AuthRepository _authRepository;

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
    } on FirebaseAuthException catch (error) {
      return ResetPasswordSubmitResult.failure(_mapFirebaseAuthError(error));
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

  String _mapFirebaseAuthError(FirebaseAuthException error) {
    switch (error.code) {
      case 'invalid-email':
        return 'Inserisci un indirizzo email valido.';
      case 'network-request-failed':
        return 'Controlla la connessione e riprova.';
      case 'too-many-requests':
        return 'Troppe richieste in poco tempo. Riprova più tardi.';
      case 'user-not-found':
        return 'Se l’email è associata a un account JiVaio, riceverai un link per reimpostare la password.';
      default:
        return 'Non è stato possibile inviare il link di recupero. Riprova.';
    }
  }
}
