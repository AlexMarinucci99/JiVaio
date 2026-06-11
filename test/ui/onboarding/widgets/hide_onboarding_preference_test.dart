import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:jivaio/ui/onboarding/widgets/hide_onboarding_preference.dart';

void main() {
  Widget buildTestWidget({
    required bool value,
    required VoidCallback onChanged,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: HideOnboardingPreference(
            value: value,
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }

  testWidgets('mostra titolo e sottotitolo della preferenza',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      buildTestWidget(
        value: false,
        onChanged: () {},
      ),
    );

    expect(find.text('Non mostrarla più'), findsOneWidget);
    expect(find.text('La salteremo la prossima volta'), findsOneWidget);
  });

  testWidgets('non mostra la spunta quando value è false',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      buildTestWidget(
        value: false,
        onChanged: () {},
      ),
    );

    expect(find.byIcon(Icons.check_rounded), findsNothing);
  });

  testWidgets('mostra la spunta quando value è true',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      buildTestWidget(
        value: true,
        onChanged: () {},
      ),
    );

    expect(find.byIcon(Icons.check_rounded), findsOneWidget);
  });

  testWidgets('esegue onChanged quando viene premuto il box',
      (WidgetTester tester) async {
    var changed = false;

    await tester.pumpWidget(
      buildTestWidget(
        value: false,
        onChanged: () {
          changed = true;
        },
      ),
    );

    await tester.tap(find.byType(InkWell));
    await tester.pump();

    expect(changed, isTrue);
  });

  testWidgets('usa AnimatedContainer per il box e la casellina',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      buildTestWidget(
        value: false,
        onChanged: () {},
      ),
    );

    expect(find.byType(AnimatedContainer), findsNWidgets(2));
  });
}