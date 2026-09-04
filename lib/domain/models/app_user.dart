/// Modello applicativo dell'utente autenticato.
class AppUser {
  const AppUser({required this.id, this.email, this.displayName});

  final String id;
  final String? email;
  final String? displayName;
}
