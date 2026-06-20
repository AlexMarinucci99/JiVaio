import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'app.dart';
import 'config/app_dependencies.dart';
import 'firebase_options.dart';

/// Inizializza le dipendenze principali e avvia JiVaio.
Future<void> main() async {
  // Serve prima di inizializzare Firebase e leggere preferenze locali.
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final dependencies = AppDependencies.create();

  final shouldSkipOnboarding = await dependencies.onboardingRepository
      .shouldSkipOnboarding();

  runApp(
    JiVaioApp(
      showOnboarding: !shouldSkipOnboarding,
      dependencies: dependencies,
    ),
  );
}
