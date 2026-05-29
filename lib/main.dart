import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'app.dart';
import 'firebase_options.dart';
import 'data/services/onboarding_preferences_service.dart';

Future<void> main() async {
  // Necessario perché prima di runApp leggiamo dati locali
  // e inizializziamo plugin come Firebase.
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final onboardingPreferencesService = OnboardingPreferencesService();

  final shouldSkipOnboarding = await onboardingPreferencesService
      .shouldSkipOnboarding();

  runApp(JiVaioApp(showOnboarding: !shouldSkipOnboarding));
}
