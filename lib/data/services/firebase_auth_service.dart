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
  FirebaseAuthService({FirebaseAuth? firebaseAuth, GoogleSignIn? googleSignIn})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
      _googleSignIn = googleSignIn ?? GoogleSignIn.instance;

  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  Future<void>? _googleSignInInitialization;

  @override
  AppUser? get currentUser => _mapUser(_firebaseAuth.currentUser);

  @override
  Stream<AppUser?> authStateChanges() =>
      _firebaseAuth.authStateChanges().map(_mapUser);

  @override
  Future<void> login({required String email, required String password}) =>
      _runFirebaseOperation(() async {
        await _firebaseAuth.signInWithEmailAndPassword(
          email: email.trim(),
          password: password,
        );
      });

  @override
  Future<void> loginWithGoogle() => _runGoogleOperation(() async {
    await _ensureGoogleSignInInitialized();

    if (!_googleSignIn.supportsAuthenticate()) {
      throw const AuthFailure(AuthFailureCode.operationNotAllowed);
    }

    final googleUser = await _googleSignIn.authenticate();
    final idToken = googleUser.authentication.idToken;

    if (idToken == null) {
      throw const AuthFailure(AuthFailureCode.invalidCredential);
    }

    final credential = GoogleAuthProvider.credential(idToken: idToken);
    await _firebaseAuth.signInWithCredential(credential);
  });

  @override
  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) => _runFirebaseOperation(() async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    await credential.user?.updateDisplayName(name.trim());
  });

  @override
  Future<void> logout() async {
    await _runFirebaseOperation(_firebaseAuth.signOut);
    await _signOutFromGoogle();
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) =>
      _runFirebaseOperation(
        () => _firebaseAuth.sendPasswordResetEmail(email: email.trim()),
      );

  Future<void> _ensureGoogleSignInInitialized() =>
      _googleSignInInitialization ??= _googleSignIn.initialize();

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
      // Il logout Firebase resta valido anche se Google non è disponibile.
    }
  }

  AppUser? _mapUser(User? user) => user == null
      ? null
      : AppUser(id: user.uid, email: user.email, displayName: user.displayName);

  AuthFailureCode _mapFirebaseAuthFailureCode(String code) => switch (code) {
    'invalid-email' => AuthFailureCode.invalidEmail,
    'user-not-found' => AuthFailureCode.userNotFound,
    'wrong-password' => AuthFailureCode.wrongPassword,
    'email-already-in-use' => AuthFailureCode.emailAlreadyInUse,
    'weak-password' => AuthFailureCode.weakPassword,
    'network-request-failed' => AuthFailureCode.networkRequestFailed,
    'invalid-credential' => AuthFailureCode.invalidCredential,
    'too-many-requests' => AuthFailureCode.tooManyRequests,
    'user-disabled' => AuthFailureCode.userDisabled,
    'operation-not-allowed' => AuthFailureCode.operationNotAllowed,
    _ => AuthFailureCode.unknown,
  };

  AuthFailureCode _mapGoogleSignInFailureCode(GoogleSignInExceptionCode code) =>
      switch (code) {
        GoogleSignInExceptionCode.canceled => AuthFailureCode.cancelled,
        GoogleSignInExceptionCode.clientConfigurationError ||
        GoogleSignInExceptionCode.providerConfigurationError ||
        GoogleSignInExceptionCode.uiUnavailable =>
          AuthFailureCode.operationNotAllowed,
        GoogleSignInExceptionCode.interrupted =>
          AuthFailureCode.networkRequestFailed,
        GoogleSignInExceptionCode.userMismatch =>
          AuthFailureCode.invalidCredential,
        GoogleSignInExceptionCode.unknownError => AuthFailureCode.unknown,
      };
}
