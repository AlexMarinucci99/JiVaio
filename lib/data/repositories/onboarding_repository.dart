import '../services/onboarding_preferences_service.dart';

/// Gestisce l'accesso alla preferenza di visualizzazione dell'onboarding.
///
/// Espone al resto dell'app un'API stabile e nasconde il service
/// responsabile della persistenza locale.
class OnboardingRepository {
  OnboardingRepository(this._preferencesService);

  final OnboardingPreferencesService _preferencesService;

  Future<bool> shouldSkipOnboarding() =>
      _preferencesService.shouldSkipOnboarding();

  Future<void> setSkipOnboarding(bool value) =>
      _preferencesService.setSkipOnboarding(value);
}
