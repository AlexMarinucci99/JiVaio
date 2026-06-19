import 'package:shared_preferences/shared_preferences.dart';

/// Gestisce la preferenza locale relativa alla visualizzazione dell'onboarding.
///
/// Il servizio incapsula l'accesso a [SharedPreferencesAsync], così il resto
/// dell'app non dipende direttamente dal meccanismo di persistenza locale.
class OnboardingPreferencesService {
  static const String _skipOnboardingKey = 'skip_onboarding';

  final SharedPreferencesAsync _preferences = SharedPreferencesAsync();

  /// Restituisce true se l'utente ha scelto di saltare l'onboarding.
  Future<bool> shouldSkipOnboarding() async {
    return await _preferences.getBool(_skipOnboardingKey) ?? false;
  }

  /// Salva la scelta dell'utente sulla visualizzazione dell'onboarding.
  Future<void> setSkipOnboarding(bool value) async {
    await _preferences.setBool(_skipOnboardingKey, value);
  }
}
