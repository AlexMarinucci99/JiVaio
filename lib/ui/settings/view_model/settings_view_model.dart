import '../../../domain/models/app_user.dart';

/// Prepara i dati dell'utente per la schermata Impostazioni.
class SettingsViewModel {
  const SettingsViewModel({required this.user});

  final AppUser? user;

  /// Indica se l'app è utilizzata senza autenticazione.
  bool get isGuest => user == null;

  /// Titolo mostrato nella card superiore.
  String get profileTitle => isGuest
      ? 'Modalità ospite'
      : _valueOrFallback(user?.displayName, 'Account personale');

  /// Descrizione mostrata sotto il titolo della card.
  String get profileSubtitle => isGuest
      ? 'Accedi per personalizzare la tua esperienza.'
      : _valueOrFallback(user?.email, 'Account autenticato');

  static String _valueOrFallback(String? value, String fallback) {
    final normalizedValue = value?.trim();

    return normalizedValue == null || normalizedValue.isEmpty
        ? fallback
        : normalizedValue;
  }
}
