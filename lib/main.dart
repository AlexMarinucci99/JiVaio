import 'package:flutter/material.dart';

import 'app.dart';
import 'data/services/onboarding_preferences_service.dart';

Future<void> main() async {
  // Necessario perché prima di runApp leggiamo un dato locale asincrono.
  WidgetsFlutterBinding.ensureInitialized();

  // Servizio che legge la preferenza salvata sull'onboarding.
  final onboardingPreferencesService = OnboardingPreferencesService();

  // true = l'utente in passato ha scelto di non vedere più l'onboarding.
  final shouldSkipOnboarding = await onboardingPreferencesService
      .shouldSkipOnboarding();

  runApp(JiVaioApp(showOnboarding: !shouldSkipOnboarding));
}
