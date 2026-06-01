import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'app.dart';
import 'config/app_dependencies.dart';
import 'data/services/onboarding_preferences_service.dart';
import 'firebase_options.dart';

Future<void> main() async {
  // Necessario perché prima di runApp leggiamo dati locali
  // e inizializziamo plugin come Firebase.
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final onboardingPreferencesService = OnboardingPreferencesService();

  final shouldSkipOnboarding = await onboardingPreferencesService
      .shouldSkipOnboarding();

  // Le dipendenze vengono costruite dopo l'inizializzazione di Firebase.
  final dependencies = AppDependencies.create();

  runApp(
    JiVaioApp(
      showOnboarding: !shouldSkipOnboarding,
      dependencies: dependencies,
    ),
  );
}
