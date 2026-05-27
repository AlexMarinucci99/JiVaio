import 'package:firebase_auth/firebase_auth.dart';

import '../services/auth_service.dart';

class AuthRepository {

  const AuthRepository(this._authService);

  final AuthService _authService;

  User? get currentUser => _authService.currentUser;

  Stream<User?> get authStateChanges {
    return _authService.authStateChanges();
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    await _authService.login(
      email: email,
      password: password,
    );
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    await _authService.register(
      name: name,
      email: email,
      password: password,
    );
  }

  Future<void> logout() async {
    await _authService.logout();
  }

  Future<void> sendPasswordResetEmail({
    required String email,
  }) async {
    await _authService.sendPasswordResetEmail(email: email);
  }
}
