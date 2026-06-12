import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:jivaio/ui/core/widgets/app_segmented_nsave.dart';

void main() {
  Widget buildTestWidget({
    required String label,
    required Color backgroundColor,
    required Color textColor,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: AppSegmentedNSave(
            label: label,
            backgroundColor: backgroundColor,
            textColor: textColor,
          ),
        ),
      ),
    );
  }

  testWidgets('mostra la label del badge', (WidgetTester tester) async {
    await tester.pumpWidget(
      buildTestWidget(
        label: '3',
        backgroundColor: const Color(0xFF191970),
        textColor: Colors.white,
      ),
    );

    expect(find.text('3'), findsOneWidget);
  });

  testWidgets('usa dimensioni fisse per il badge', (WidgetTester tester) async {
    await tester.pumpWidget(
      buildTestWidget(
        label: '5',
        backgroundColor: const Color(0xFF191970),
        textColor: Colors.white,
      ),
    );

    final container = tester.widget<Container>(find.byType(Container));

    expect(container.constraints?.maxWidth, 24);
    expect(container.constraints?.maxHeight, 24);
  });

  testWidgets('applica il colore di sfondo passato al widget', (
    WidgetTester tester,
  ) async {
    const backgroundColor = Color(0xFF0B7A55);

    await tester.pumpWidget(
      buildTestWidget(
        label: '2',
        backgroundColor: backgroundColor,
        textColor: Colors.white,
      ),
    );

    final container = tester.widget<Container>(find.byType(Container));
    final decoration = container.decoration as BoxDecoration;

    expect(decoration.color, backgroundColor);
  });

  testWidgets('applica il colore del testo passato al widget', (
    WidgetTester tester,
  ) async {
    const textColor = Color(0xFF191970);

    await tester.pumpWidget(
      buildTestWidget(
        label: '7',
        backgroundColor: Colors.white,
        textColor: textColor,
      ),
    );

    final text = tester.widget<Text>(find.text('7'));

    expect(text.style?.color, textColor);
  });

  testWidgets('mostra correttamente anche label testuali', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      buildTestWidget(
        label: '9+',
        backgroundColor: const Color(0xFF191970),
        textColor: Colors.white,
      ),
    );

    expect(find.text('9+'), findsOneWidget);
  });
}
