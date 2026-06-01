class SettingsViewModel {
  const SettingsViewModel({required this.isGuest});

  // Indica se l'utente sta utilizzando l'app senza autenticazione.
  final bool isGuest;

  // Le impostazioni legate all'account saranno disponibili
  // soltanto per gli utenti autenticati.
  bool get canManageAccount => !isGuest;
}
