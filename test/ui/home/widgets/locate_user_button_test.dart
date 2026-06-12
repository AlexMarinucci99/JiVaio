import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:jivaio/ui/home/widgets/locate_user_button.dart';

void main() {
  Widget buildTestWidget({
    required VoidCallback onPressed,
    required bool isLoading,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: LocateUserButton(onPressed: onPressed, isLoading: isLoading),
        ),
      ),
    );
  }

  testWidgets('mostra icona posizione quando non è in caricamento', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      buildTestWidget(isLoading: false, onPressed: () {}),
    );

    expect(find.byIcon(Icons.my_location_rounded), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('mostra loader quando è in caricamento', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildTestWidget(isLoading: true, onPressed: () {}));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.byIcon(Icons.my_location_rounded), findsNothing);
  });

  testWidgets(
    'esegue la callback quando viene premuto e non è in caricamento',
    (WidgetTester tester) async {
      var pressed = false;

      await tester.pumpWidget(
        buildTestWidget(
          isLoading: false,
          onPressed: () {
            pressed = true;
          },
        ),
      );

      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      expect(pressed, isTrue);
    },
  );

  testWidgets('non esegue la callback quando è in caricamento', (
    WidgetTester tester,
  ) async {
    var pressed = false;

    await tester.pumpWidget(
      buildTestWidget(
        isLoading: true,
        onPressed: () {
          pressed = true;
        },
      ),
    );

    await tester.tap(find.byType(InkWell));

    // Non usare pumpAndSettle qui:
    // CircularProgressIndicator ha un'animazione continua.
    await tester.pump();

    expect(pressed, isFalse);
  });

  testWidgets('espone la label semantica per accessibilità', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      buildTestWidget(isLoading: false, onPressed: () {}),
    );

    expect(find.bySemanticsLabel('Mostra la mia posizione'), findsOneWidget);
  });
}
