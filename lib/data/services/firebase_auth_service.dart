import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../domain/exceptions/auth_failure.dart';
import '../../domain/models/app_user.dart';
import 'auth_service.dart';

/// Implementa [AuthService] usando Firebase Authentication.
///
/// Questo service è l'unico punto dell'app che dipende direttamente
/// da [FirebaseAuth] e traduce gli errori Firebase in errori di dominio.
class FirebaseAuthService implements AuthService {
  FirebaseAuthService({
    FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
  }) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
       _googleSignIn = googleSignIn ?? GoogleSignIn.instance;

  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  Future<void>? _googleSignInInitialization;

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
  Future<void> loginWithGoogle() async {
    await _runGoogleOperation(() async {
      await _ensureGoogleSignInInitialized();

      if (!_googleSignIn.supportsAuthenticate()) {
        throw const AuthFailure(AuthFailureCode.operationNotAllowed);
      }

      final googleUser = await _googleSignIn.authenticate();
      final googleAuth = googleUser.authentication;
      final idToken = googleAuth.idToken;

      if (idToken == null) {
        throw const AuthFailure(AuthFailureCode.invalidCredential);
      }

      final credential = GoogleAuthProvider.credential(idToken: idToken);
      await _firebaseAuth.signInWithCredential(credential);
    });
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
    await _signOutFromGoogle();
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) async {
    await _runFirebaseOperation(
      () => _firebaseAuth.sendPasswordResetEmail(email: email.trim()),
    );
  }

  Future<void> _ensureGoogleSignInInitialized() {
    return _googleSignInInitialization ??= _googleSignIn.initialize();
  }

  Future<T> _runFirebaseOperation<T>(Future<T> Function() operation) async {
    try {
      return await operation();
    } on FirebaseAuthException catch (error) {
      throw AuthFailure(_mapFirebaseAuthFailureCode(error.code));
    }
  }

  Future<T> _runGoogleOperation<T>(Future<T> Function() operation) async {
    try {
      return await operation();
    } on AuthFailure {
      rethrow;
    } on FirebaseAuthException catch (error) {
      throw AuthFailure(_mapFirebaseAuthFailureCode(error.code));
    } on GoogleSignInException catch (error) {
      throw AuthFailure(_mapGoogleSignInFailureCode(error.code));
    }
  }

  Future<void> _signOutFromGoogle() async {
    try {
      await _ensureGoogleSignInInitialized();
      await _googleSignIn.signOut();
    } on GoogleSignInException {
      // Il logout Firebase resta valido anche se il provider Google non è disponibile.
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

  AuthFailureCode _mapGoogleSignInFailureCode(GoogleSignInExceptionCode code) {
    switch (code) {
      case GoogleSignInExceptionCode.canceled:
        return AuthFailureCode.cancelled;
      case GoogleSignInExceptionCode.clientConfigurationError:
      case GoogleSignInExceptionCode.providerConfigurationError:
      case GoogleSignInExceptionCode.uiUnavailable:
        return AuthFailureCode.operationNotAllowed;
      case GoogleSignInExceptionCode.interrupted:
        return AuthFailureCode.networkRequestFailed;
      case GoogleSignInExceptionCode.userMismatch:
        return AuthFailureCode.invalidCredential;
      case GoogleSignInExceptionCode.unknownError:
        return AuthFailureCode.unknown;
    }
  }
}
