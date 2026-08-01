import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'jivaio_app.dart';
import 'config/app_dependencies.dart';
import 'firebase_options.dart';

/// Inizializza le dipendenze principali e avvia JiVaio.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (error, stackTrace) {
    debugPrint('Errore durante l’inizializzazione di Firebase: $error');
    debugPrint('$stackTrace');

    runApp(
      const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: SafeArea(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'Impossibile avviare JiVaio.\n'
                  'Chiudi e riapri l’app per riprovare.',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ),
    );

    return;
  }

  final dependencies = AppDependencies.create();

  var shouldSkipOnboarding = false;

  try {
    shouldSkipOnboarding = await dependencies.onboardingRepository
        .shouldSkipOnboarding();
  } catch (error, stackTrace) {
    debugPrint('Errore durante la lettura delle preferenze: $error');
    debugPrint('$stackTrace');
  }

  runApp(
    JiVaioApp(
      showOnboarding: !shouldSkipOnboarding,
      dependencies: dependencies,
    ),
  );
}
