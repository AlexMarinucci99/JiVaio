import '../../domain/models/app_user.dart';

/// Contratto per le sorgenti dati di autenticazione.
///
/// Permette al repository di non dipendere direttamente da Firebase
/// e rende sostituibile la sorgente dati nei test o in future implementazioni.
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
