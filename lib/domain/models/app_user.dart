/// Modello applicativo dell'utente autenticato.
///
/// Non dipende da Firebase: può essere utilizzato dal routing,
/// dai ViewModel e dalla UI senza conoscere il provider esterno.
class AppUser {
  const AppUser({required this.id, this.email, this.displayName});

  final String id;
  final String? email;
  final String? displayName;
}
