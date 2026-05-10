import 'package:shared_preferences/shared_preferences.dart';

class OnboardingPreferencesService {
  static const String _skipOnboardingKey = 'skip_onboarding';
//questservizio legge se l'onboarding va saltato e salva la scelta dell'utente
  final SharedPreferencesAsync _preferences = SharedPreferencesAsync();

  Future<bool> shouldSkipOnboarding() async {
    return await _preferences.getBool(_skipOnboardingKey) ?? false;
  }

  Future<void> setSkipOnboarding(bool value) async {
    await _preferences.setBool(_skipOnboardingKey, value);
  }
}