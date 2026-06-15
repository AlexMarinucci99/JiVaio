import '../../../domain/models/app_user.dart';

/// Gestisce i dati necessari alla schermata Impostazioni.
///
/// Riceve il modello applicativo dell'utente e lo trasforma
/// in informazioni direttamente utilizzabili dalla UI.
class SettingsViewModel {
  const SettingsViewModel({
    required this.user,
  });

  /// Utente autenticato.
  ///
  /// È null quando JiVaio viene utilizzata in modalità guest.
  final AppUser? user;

  /// Indica se l'app è utilizzata senza autenticazione.
  bool get isGuest => user == null;

  /// Le operazioni di gestione account sono disponibili
  /// soltanto per un utente autenticato.
  bool get canManageAccount => user != null;

  /// Titolo mostrato nella card superiore.
  String get profileTitle {
    final currentUser = user;

    if (currentUser == null) {
      return 'Modalità ospite';
    }

    final displayName = currentUser.displayName?.trim();

    if (displayName != null && displayName.isNotEmpty) {
      return displayName;
    }

    return 'Account personale';
  }

  /// Descrizione mostrata sotto il titolo della card.
  String get profileSubtitle {
    final currentUser = user;

    if (currentUser == null) {
      return 'Accedi per personalizzare la tua esperienza.';
    }

    final email = currentUser.email?.trim();

    if (email != null && email.isNotEmpty) {
      return email;
    }

    return 'Account autenticato';
  }
}