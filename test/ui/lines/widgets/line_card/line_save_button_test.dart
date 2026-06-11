import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:jivaio/ui/lines/widgets/line_card/line_save_button.dart';

void main() {
  Widget buildTestWidget({
    required bool isSaved,
    required VoidCallback onPressed,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: LineSaveButton(
            isSaved: isSaved,
            onPressed: onPressed,
          ),
        ),
      ),
    );
  }

  testWidgets('mostra cuore vuoto quando la linea non è salvata',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      buildTestWidget(
        isSaved: false,
        onPressed: () {},
      ),
    );

    expect(find.byIcon(Icons.favorite_border_rounded), findsOneWidget);
  });

  testWidgets('mostra cuore pieno quando la linea è salvata',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      buildTestWidget(
        isSaved: true,
        onPressed: () {},
      ),
    );

    expect(find.byIcon(Icons.favorite_rounded), findsOneWidget);
  });

  testWidgets('esegue la callback al tap', (WidgetTester tester) async {
    var pressed = false;

    await tester.pumpWidget(
      buildTestWidget(
        isSaved: false,
        onPressed: () {
          pressed = true;
        },
      ),
    );

    await tester.tap(find.byType(LineSaveButton));
    await tester.pumpAndSettle();

    expect(pressed, isTrue);
  });
}