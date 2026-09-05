import '../services/onboarding_preferences_service.dart';

/// Gestisce l'accesso alla preferenza di visualizzazione dell'onboarding.
class OnboardingRepository {
  OnboardingRepository(this._preferencesService);

  final OnboardingPreferencesService _preferencesService;

  Future<bool> shouldSkipOnboarding() =>
      _preferencesService.shouldSkipOnboarding();

  Future<void> setSkipOnboarding(bool value) =>
      _preferencesService.setSkipOnboarding(value);
}
