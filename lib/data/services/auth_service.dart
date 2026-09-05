import '../../domain/models/app_user.dart';

/// Definisce il contratto per le sorgenti dati di autenticazione.

abstract class AuthService {
  AppUser? get currentUser;
  Stream<AppUser?> authStateChanges();
  Future<void> login({required String email, required String password});
  Future<void> loginWithGoogle();
  Future<void> register({
    required String name,
    required String email,
    required String password,
  });

  Future<void> logout();
  Future<void> sendPasswordResetEmail({required String email});
}
