import '../../domain/models/app_user.dart';
import '../services/auth_service.dart';

/// Gestisce l'accesso ai dati di autenticazione.
///
/// Espone al resto dell'app un'API stabile e indipendente
/// dall'implementazione concreta di [AuthService].
class AuthRepository {
  const AuthRepository(this._authService);

  final AuthService _authService;

  AppUser? get currentUser => _authService.currentUser;

  Stream<AppUser?> get authStateChanges => _authService.authStateChanges();

  Future<void> login({required String email, required String password}) =>
      _authService.login(email: email, password: password);

  Future<void> loginWithGoogle() => _authService.loginWithGoogle();

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) => _authService.register(name: name, email: email, password: password);

  Future<void> logout() => _authService.logout();

  Future<void> sendPasswordResetEmail({required String email}) =>
      _authService.sendPasswordResetEmail(email: email);
}
