import '../../domain/models/app_user.dart';

/// Definisce il contratto per le sorgenti dati di autenticazione.
///
/// Il repository dipende da questa astrazione invece che da Firebase,
/// così la sorgente dati può essere sostituita nei test o in implementazioni future.
abstract class AuthService {
  /// Restituisce l'utente autenticato corrente, se presente.
  AppUser? get currentUser;

  /// Osserva i cambiamenti dello stato di autenticazione.
  Stream<AppUser?> authStateChanges();

  /// Effettua l'accesso con email e password.
  Future<void> login({required String email, required String password});

  /// Registra un nuovo utente con nome, email e password.
  Future<void> register({
    required String name,
    required String email,
    required String password,
  });

  /// Termina la sessione dell'utente corrente.
  Future<void> logout();

  /// Invia l'email per il recupero della password.
  Future<void> sendPasswordResetEmail({required String email});
}
