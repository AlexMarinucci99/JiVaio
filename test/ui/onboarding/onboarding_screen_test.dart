import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:jivaio/data/repositories/onboarding_repository.dart';
import 'package:jivaio/data/services/onboarding_preferences_service.dart';
import 'package:jivaio/routing/app_routes.dart';
import 'package:jivaio/ui/onboarding/view_model/onboarding_view_model.dart';
import 'package:jivaio/ui/onboarding/widgets/hide_onboarding_preference.dart';
import 'package:jivaio/ui/onboarding/widgets/onboarding_screen.dart';

import '../../helpers/widget_test_helpers.dart';

class _MemoryPreferences implements OnboardingPreferencesService {
  bool skip = false;
  final writes = <bool>[];
  Completer<void>? pending;

  @override
  Future<bool> shouldSkipOnboarding() async => skip;

  @override
  Future<void> setSkipOnboarding(bool value) async {
    writes.add(value);
    await pending?.future;
    skip = value;
  }
}

void main() {
  late _MemoryPreferences preferences;
  setUp(() => preferences = _MemoryPreferences());

  Future<void> mount(WidgetTester tester) async {
    await usePhoneSurface(tester);
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => OnboardingViewModel(
          onboardingRepository: OnboardingRepository(preferences),
        ),
        child: MaterialApp(
          home: const OnboardingScreen(),
          routes: {
            AppRoutes.authChoice: (_) =>
                const Scaffold(body: Text('Destinazione accesso')),
          },
        ),
      ),
    );
  }

  Future<void> lastPage(WidgetTester tester) async {
    await tapVisible(tester, find.text('Avanti'));
    await tapVisible(tester, find.text('Avanti'));
  }

  testWidgets('mostra le slide e aggiorna i controlli con avanti e indietro', (
    tester,
  ) async {
    await mount(tester);
    expect(find.text('Trova la tua Fermata'), findsOneWidget);
    expect(find.text('Indietro'), findsNothing);
    await tapVisible(tester, find.text('Avanti'));
    expect(find.text('Orari a portata di mano'), findsOneWidget);
    expect(find.text('Indietro'), findsOneWidget);
    await tapVisible(tester, find.text('Indietro'));
    expect(find.text('Trova la tua Fermata'), findsOneWidget);
    expect(find.text('Indietro'), findsNothing);
    await lastPage(tester);
    expect(find.text('Viaggia con più semplicità'), findsOneWidget);
    expect(find.text('Inizia'), findsOneWidget);
    expect(find.text('Salta'), findsNothing);
    expect(find.text('Non mostrarla più'), findsOneWidget);
  });

  testWidgets('salta verso accesso senza scrivere la preferenza', (
    tester,
  ) async {
    await mount(tester);
    await tapVisible(tester, find.text('Salta'));
    expect(find.text('Destinazione accesso'), findsOneWidget);
    expect(find.byType(OnboardingScreen), findsNothing);
    expect(preferences.writes, isEmpty);
    expect(
      Navigator.of(tester.element(find.text('Destinazione accesso'))).canPop(),
      isFalse,
    );
  });

  for (final hide in [false, true]) {
    testWidgets('completa salvando la preferenza $hide in memoria isolata', (
      tester,
    ) async {
      await mount(tester);
      await lastPage(tester);
      if (hide) await tapVisible(tester, find.text('Non mostrarla più'));
      expect(
        tester
            .widget<HideOnboardingPreference>(
              find.byType(HideOnboardingPreference),
            )
            .value,
        hide,
      );
      await tapVisible(tester, find.text('Inizia'));
      expect(preferences.writes, [hide]);
      expect(
        await OnboardingRepository(preferences).shouldSkipOnboarding(),
        hide,
      );
      expect(find.text('Destinazione accesso'), findsOneWidget);
    });
  }

  testWidgets('attende la persistenza evitando completamenti duplicati', (
    tester,
  ) async {
    preferences.pending = Completer<void>();
    await mount(tester);
    await lastPage(tester);
    await tapVisible(tester, find.text('Non mostrarla più'));
    await tapVisible(tester, find.text('Inizia'));
    await tapVisible(tester, find.text('Inizia'));
    expect(preferences.writes, [true]);
    expect(find.text('Destinazione accesso'), findsNothing);
    preferences.pending!.complete();
    await tester.pumpAndSettle();
    expect(find.text('Destinazione accesso'), findsOneWidget);
  });

  testWidgets('prosegue verso accesso anche se la preferenza non viene salvata', (
    tester,
  ) async {
    preferences.pending = Completer<void>();
    await mount(tester);
    await lastPage(tester);
    await tapVisible(tester, find.text('Non mostrarla più'));
    await tapVisible(tester, find.text('Inizia'));
    preferences.pending!.completeError(StateError('Scrittura non disponibile'));
    await tester.pumpAndSettle();
    expect(find.text('Destinazione accesso'), findsOneWidget);
    expect(
      find.text(
        'Non è stato possibile salvare la preferenza. L’onboarding potrebbe essere mostrato di nuovo.',
      ),
      findsOneWidget,
    );
    expect(preferences.skip, isFalse);
  });
}
