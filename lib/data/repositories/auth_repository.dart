import '../../domain/models/app_user.dart';
import '../services/auth_service.dart';

/// Repository responsabile dell'accesso ai dati di autenticazione.
///
/// Espone al resto dell'app un'API indipendente dal provider concreto.
class AuthRepository {
  const AuthRepository(this._authService);

  final AuthService _authService;

  AppUser? get currentUser {
    return _authService.currentUser;
  }

  Stream<AppUser?> get authStateChanges {
    return _authService.authStateChanges();
  }

  Future<void> login({required String email, required String password}) {
    return _authService.login(email: email, password: password);
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) {
    return _authService.register(name: name, email: email, password: password);
  }

  Future<void> logout() {
    return _authService.logout();
  }

  Future<void> sendPasswordResetEmail({required String email}) {
    return _authService.sendPasswordResetEmail(email: email);
  }
}
