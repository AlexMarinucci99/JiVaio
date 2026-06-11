import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/exceptions/auth_failure.dart';
import '../../domain/models/app_user.dart';
import '../services/auth_service.dart';

/// Repository responsabile dell'accesso ai dati di autenticazione.
///
/// Firebase resta confinato nel data layer.
/// Il resto dell'app riceve soltanto AppUser e AuthFailure.
class AuthRepository {
  const AuthRepository(this._authService);

  final AuthService _authService;

  AppUser? get currentUser {
    return _mapUser(_authService.currentUser);
  }

  Stream<AppUser?> get authStateChanges {
    return _authService.authStateChanges().map(_mapUser);
  }

  Future<void> login({required String email, required String password}) async {
    await _runAuthOperation(
      () => _authService.login(email: email, password: password),
    );
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    await _runAuthOperation(
      () => _authService.register(name: name, email: email, password: password),
    );
  }

  Future<void> logout() async {
    await _runAuthOperation(_authService.logout);
  }

  Future<void> sendPasswordResetEmail({required String email}) async {
    await _runAuthOperation(
      () => _authService.sendPasswordResetEmail(email: email),
    );
  }

  Future<void> _runAuthOperation(Future<void> Function() operation) async {
    try {
      await operation();
    } on FirebaseAuthException catch (error) {
      throw AuthFailure(_mapFirebaseAuthFailureCode(error.code));
    }
  }

  AppUser? _mapUser(User? user) {
    if (user == null) {
      return null;
    }

    return AppUser(
      id: user.uid,
      email: user.email,
      displayName: user.displayName,
    );
  }

  AuthFailureCode _mapFirebaseAuthFailureCode(String code) {
    switch (code) {
      case 'invalid-email':
        return AuthFailureCode.invalidEmail;
      case 'user-not-found':
        return AuthFailureCode.userNotFound;
      case 'wrong-password':
        return AuthFailureCode.wrongPassword;
      case 'email-already-in-use':
        return AuthFailureCode.emailAlreadyInUse;
      case 'weak-password':
        return AuthFailureCode.weakPassword;
      case 'network-request-failed':
        return AuthFailureCode.networkRequestFailed;
      case 'invalid-credential':
        return AuthFailureCode.invalidCredential;
      case 'too-many-requests':
        return AuthFailureCode.tooManyRequests;
      case 'user-disabled':
        return AuthFailureCode.userDisabled;
      case 'operation-not-allowed':
        return AuthFailureCode.operationNotAllowed;
      default:
        return AuthFailureCode.unknown;
    }
  }
}
