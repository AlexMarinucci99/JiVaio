import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/exceptions/auth_failure.dart';
import '../../domain/models/app_user.dart';
import 'auth_service.dart';

/// Implementa [AuthService] usando Firebase Authentication.
///
/// Questo service è l'unico punto dell'app che dipende direttamente
/// da [FirebaseAuth] e traduce gli errori Firebase in errori di dominio.
class FirebaseAuthService implements AuthService {
  FirebaseAuthService({FirebaseAuth? firebaseAuth})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  final FirebaseAuth _firebaseAuth;

  @override
  AppUser? get currentUser {
    return _mapUser(_firebaseAuth.currentUser);
  }

  @override
  Stream<AppUser?> authStateChanges() {
    return _firebaseAuth.authStateChanges().map(_mapUser);
  }

  @override
  Future<void> login({required String email, required String password}) async {
    await _runFirebaseOperation(
      () => _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      ),
    );
  }

  @override
  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    await _runFirebaseOperation(() async {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      await credential.user?.updateDisplayName(name.trim());
    });
  }

  @override
  Future<void> logout() async {
    await _runFirebaseOperation(_firebaseAuth.signOut);
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) async {
    await _runFirebaseOperation(
      () => _firebaseAuth.sendPasswordResetEmail(email: email.trim()),
    );
  }

  Future<T> _runFirebaseOperation<T>(Future<T> Function() operation) async {
    try {
      return await operation();
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
