import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:jivaio/ui/onboarding/widgets/onboarding_slide_card.dart';

class TestAssetBundle extends CachingAssetBundle {
  static const String testImagePath = 'assets/test/onboarding.png';

  static final Uint8List _transparentPngBytes = base64Decode(
    'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAAEklEQVR42mP8z8BQDwAFgwJ/lZ1x9QAAAABJRU5ErkJggg==',
  );

  @override
  Future<ByteData> load(String key) async {
    if (key == 'AssetManifest.bin') {
      final manifestData = const StandardMessageCodec().encodeMessage(
        <String, Object?>{
          testImagePath: <Object?>[
            <String, Object?>{
              'asset': testImagePath,
            },
          ],
        },
      );

      return manifestData!;
    }

    if (key == 'AssetManifest.json') {
      return ByteData.sublistView(
        Uint8List.fromList(
          utf8.encode(
            '{"$testImagePath":["$testImagePath"]}',
          ),
        ),
      );
    }

    if (key == testImagePath) {
      return ByteData.sublistView(_transparentPngBytes);
    }

    return ByteData.sublistView(_transparentPngBytes);
  }
}

void main() {
  Future<void> pumpSlideCard(
    WidgetTester tester, {
    String imagePath = TestAssetBundle.testImagePath,
    String title = 'Muoviti meglio',
    String description = 'Trova linee, fermate e percorsi in modo semplice.',
    IconData? icon = Icons.directions_bus_rounded,
    Color? accentColor,
    Alignment imageAlignment = Alignment.center,
    OnboardingSlideCardColors colors = const OnboardingSlideCardColors(),
  }) async {
    tester.view.physicalSize = const Size(390, 900);
    tester.view.devicePixelRatio = 1.0;

    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        home: DefaultAssetBundle(
          bundle: TestAssetBundle(),
          child: Scaffold(
            body: Center(
              child: OnboardingSlideCard(
                imagePath: imagePath,
                title: title,
                description: description,
                icon: icon,
                accentColor: accentColor,
                imageAlignment: imageAlignment,
                colors: colors,
              ),
            ),
          ),
        ),
      ),
    );

    await tester.pump();
  }

  testWidgets('mostra titolo e descrizione della slide',
      (WidgetTester tester) async {
    await pumpSlideCard(
      tester,
      title: 'Benvenuto in JiVaio',
      description: 'Consulta il trasporto urbano in modo più chiaro.',
    );

    expect(find.text('Benvenuto in JiVaio'), findsOneWidget);
    expect(
      find.text('Consulta il trasporto urbano in modo più chiaro.'),
      findsOneWidget,
    );
  });

  testWidgets('mostra immagine asset della slide',
      (WidgetTester tester) async {
    await pumpSlideCard(tester);

    expect(find.byType(Image), findsOneWidget);

    final image = tester.widget<Image>(find.byType(Image));
    final provider = image.image as AssetImage;

    expect(provider.assetName, TestAssetBundle.testImagePath);
    expect(image.fit, BoxFit.cover);
    expect(image.filterQuality, FilterQuality.high);
  });

  testWidgets('mostra icona quando icon è valorizzata',
      (WidgetTester tester) async {
    await pumpSlideCard(
      tester,
      icon: Icons.map_rounded,
    );

    expect(find.byIcon(Icons.map_rounded), findsOneWidget);
  });

  testWidgets('non mostra icona quando icon è null',
      (WidgetTester tester) async {
    await pumpSlideCard(
      tester,
      icon: null,
    );

    expect(find.byIcon(Icons.directions_bus_rounded), findsNothing);
    expect(find.byType(Icon), findsNothing);
  });

  testWidgets('usa accentColor per colorare icona quando viene passato',
      (WidgetTester tester) async {
    const customAccent = Color(0xFF0B7A55);

    await pumpSlideCard(
      tester,
      icon: Icons.route_rounded,
      accentColor: customAccent,
    );

    final icon = tester.widget<Icon>(
      find.byIcon(Icons.route_rounded),
    );

    expect(icon.color, customAccent);
  });

  testWidgets('usa i colori personalizzati per titolo e descrizione',
      (WidgetTester tester) async {
    const customColors = OnboardingSlideCardColors(
      titleColor: Color(0xFF191970),
      descriptionColor: Color(0xFF0B7A55),
      accentColor: Color(0xFFCC880A),
    );

    await pumpSlideCard(
      tester,
      title: 'Titolo custom',
      description: 'Descrizione custom',
      colors: customColors,
    );

    final title = tester.widget<Text>(find.text('Titolo custom'));
    final description = tester.widget<Text>(find.text('Descrizione custom'));

    expect(title.style?.color, const Color(0xFF191970));
    expect(description.style?.color, const Color(0xFF0B7A55));
  });

  testWidgets('applica allineamento immagine passato al widget',
      (WidgetTester tester) async {
    await pumpSlideCard(
      tester,
      imageAlignment: Alignment.topCenter,
    );

    final image = tester.widget<Image>(find.byType(Image));

    expect(image.alignment, Alignment.topCenter);
  });
}