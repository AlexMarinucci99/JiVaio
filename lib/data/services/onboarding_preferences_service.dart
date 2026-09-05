import 'package:shared_preferences/shared_preferences.dart';

/// Gestisce la preferenza locale relativa alla visualizzazione dell'onboarding.
///
/// Il servizio incapsula l'accesso a [SharedPreferencesAsync].
class OnboardingPreferencesService {
  static const String _skipOnboardingKey = 'skip_onboarding';

  final SharedPreferencesAsync _preferences = SharedPreferencesAsync();

  /// Restituisce true se l'utente ha scelto di saltare l'onboarding.
  Future<bool> shouldSkipOnboarding() async =>
      await _preferences.getBool(_skipOnboardingKey) ?? false;

  Future<void> setSkipOnboarding(bool value) =>
      _preferences.setBool(_skipOnboardingKey, value);
}
