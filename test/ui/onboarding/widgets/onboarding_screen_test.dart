import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:jivaio/routing/app_routes.dart';
import 'package:jivaio/ui/onboarding/widgets/onboarding_screen.dart';

import '../../../helpers/fakes/fake_onboarding_repository.dart';

class TestOnboardingAssetBundle extends CachingAssetBundle {
  static const List<String> onboardingAssets = [
    'assets/onboarding/onboarding_1.png',
    'assets/onboarding/onboarding_2.png',
    'assets/onboarding/onboarding_3.png',
  ];

  static final Uint8List _transparentPngBytes = base64Decode(
    'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJ'
    'AAAAEklEQVR42mP8z8BQDwAFgwJ/lZ1x9QAAAABJRU5ErkJggg==',
  );

  @override
  Future<ByteData> load(String key) async {
    if (key == 'AssetManifest.bin') {
      final manifest = <String, Object?>{
        for (final asset in onboardingAssets)
          asset: <Object?>[
            <String, Object?>{'asset': asset},
          ],
      };

      final manifestData = const StandardMessageCodec().encodeMessage(manifest);

      return manifestData!;
    }

    if (key == 'AssetManifest.json') {
      final manifest = <String, List<String>>{
        for (final asset in onboardingAssets) asset: <String>[asset],
      };

      return ByteData.sublistView(
        Uint8List.fromList(utf8.encode(jsonEncode(manifest))),
      );
    }

    return ByteData.sublistView(_transparentPngBytes);
  }
}

void main() {
  late FakeOnboardingRepository onboardingRepository;

  setUp(() {
    onboardingRepository = FakeOnboardingRepository();
  });

  Future<void> pumpOnboardingScreen(WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 900);
    tester.view.devicePixelRatio = 1;

    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        routes: {
          AppRoutes.authChoice: (_) =>
              const Scaffold(body: Text('Auth choice test route')),
        },
        home: DefaultAssetBundle(
          bundle: TestOnboardingAssetBundle(),
          child: OnboardingScreen(onboardingRepository: onboardingRepository),
        ),
      ),
    );

    await tester.pump();
  }

  testWidgets('mostra correttamente la prima schermata di onboarding', (
    WidgetTester tester,
  ) async {
    await pumpOnboardingScreen(tester);

    expect(find.byType(OnboardingScreen), findsOneWidget);
    expect(find.text('Salta'), findsOneWidget);
    expect(find.text('Trova la tua Fermata'), findsOneWidget);
    expect(find.text('Avanti'), findsOneWidget);
    expect(find.text('Indietro'), findsNothing);
    expect(
      find.byKey(const ValueKey('empty_onboarding_preference')),
      findsOneWidget,
    );
  });

  testWidgets('avanza alla schermata successiva quando viene premuto Avanti', (
    WidgetTester tester,
  ) async {
    await pumpOnboardingScreen(tester);

    await tester.tap(find.text('Avanti'));
    await tester.pumpAndSettle();

    expect(find.text('Indietro'), findsOneWidget);
    expect(find.text('Salta'), findsOneWidget);
  });

  testWidgets('torna alla prima schermata quando viene premuto Indietro', (
    WidgetTester tester,
  ) async {
    await pumpOnboardingScreen(tester);

    await tester.tap(find.text('Avanti'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Indietro'));
    await tester.pumpAndSettle();

    expect(find.text('Trova la tua Fermata'), findsOneWidget);
    expect(find.text('Indietro'), findsNothing);
  });

  testWidgets('salta onboarding e naviga alla scelta di accesso', (
    WidgetTester tester,
  ) async {
    await pumpOnboardingScreen(tester);

    await tester.tap(find.text('Salta'));
    await tester.pumpAndSettle();

    expect(find.text('Auth choice test route'), findsOneWidget);
    expect(find.byType(OnboardingScreen), findsNothing);
  });
}
