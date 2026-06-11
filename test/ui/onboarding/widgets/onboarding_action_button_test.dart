import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:jivaio/ui/onboarding/widgets/onboarding_action_button.dart';

void main() {
  Widget buildTestWidget({
    required String label,
    required VoidCallback? onPressed,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: OnboardingActionButton(
            label: label,
            onPressed: onPressed,
          ),
        ),
      ),
    );
  }

  testWidgets('mostra il testo del bottone', (WidgetTester tester) async {
    await tester.pumpWidget(
      buildTestWidget(
        label: 'Continua',
        onPressed: () {},
      ),
    );

    expect(find.text('Continua'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
  });

  testWidgets('esegue la callback quando viene premuto',
      (WidgetTester tester) async {
    var pressed = false;

    await tester.pumpWidget(
      buildTestWidget(
        label: 'Continua',
        onPressed: () {
          pressed = true;
        },
      ),
    );

    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    expect(pressed, isTrue);
  });

  testWidgets('il bottone è disabilitato quando onPressed è null',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      buildTestWidget(
        label: 'Continua',
        onPressed: null,
      ),
    );

    final button = tester.widget<ElevatedButton>(
      find.byType(ElevatedButton),
    );

    expect(button.onPressed, isNull);
    expect(find.text('Continua'), findsOneWidget);
  });
}