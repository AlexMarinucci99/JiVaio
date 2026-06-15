import '../services/onboarding_preferences_service.dart';

class OnboardingRepository {
  OnboardingRepository(this._preferencesService);

  final OnboardingPreferencesService _preferencesService;

  Future<bool> shouldSkipOnboarding() {
    return _preferencesService.shouldSkipOnboarding();
  }

  Future<void> setSkipOnboarding(bool value) {
    return _preferencesService.setSkipOnboarding(value);
  }
}
