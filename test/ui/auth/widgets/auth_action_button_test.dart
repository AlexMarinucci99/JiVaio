import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:jivaio/ui/auth/widgets/auth_action_button.dart';

void main() {
  Widget buildTestWidget({
    required String label,
    required VoidCallback? onPressed,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: AuthActionButton(
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
        label: 'Accedi',
        onPressed: () {},
      ),
    );

    expect(find.text('Accedi'), findsOneWidget);
    expect(find.byType(TextButton), findsOneWidget);
  });

  testWidgets('esegue la callback quando viene premuto',
      (WidgetTester tester) async {
    var pressed = false;

    await tester.pumpWidget(
      buildTestWidget(
        label: 'Accedi',
        onPressed: () {
          pressed = true;
        },
      ),
    );

    await tester.tap(find.text('Accedi'));
    await tester.pumpAndSettle();

    expect(pressed, isTrue);
  });

  testWidgets('non esegue la callback quando il bottone è disabilitato',
      (WidgetTester tester) async {
    var pressed = false;

    await tester.pumpWidget(
      buildTestWidget(
        label: 'Accedi',
        onPressed: null,
      ),
    );

    await tester.tap(find.text('Accedi'));
    await tester.pumpAndSettle();

    expect(pressed, isFalse);
  });
}