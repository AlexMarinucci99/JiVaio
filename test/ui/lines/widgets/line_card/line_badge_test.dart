import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:jivaio/ui/lines/widgets/line_card/line_badge.dart';

void main() {
  Widget buildTestWidget({
    required String shortName,
    required Color backgroundColor,
    required Color textColor,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: LineBadge(
            shortName: shortName,
            backgroundColor: backgroundColor,
            textColor: textColor,
          ),
        ),
      ),
    );
  }

  testWidgets('mostra il nome breve della linea', (WidgetTester tester) async {
    await tester.pumpWidget(
      buildTestWidget(
        shortName: '1',
        backgroundColor: const Color(0xFF191970),
        textColor: Colors.white,
      ),
    );

    expect(find.text('1'), findsOneWidget);
  });

  testWidgets('usa dimensioni fisse per il badge', (WidgetTester tester) async {
    await tester.pumpWidget(
      buildTestWidget(
        shortName: 'A',
        backgroundColor: const Color(0xFF191970),
        textColor: Colors.white,
      ),
    );

    final container = tester.widget<Container>(find.byType(Container));

    expect(container.constraints?.maxWidth, 48);
    expect(container.constraints?.maxHeight, 48);
  });

  testWidgets('applica il colore di sfondo passato al widget', (
    WidgetTester tester,
  ) async {
    const backgroundColor = Color(0xFF0B7A55);

    await tester.pumpWidget(
      buildTestWidget(
        shortName: '2',
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
        shortName: '3',
        backgroundColor: Colors.white,
        textColor: textColor,
      ),
    );

    final text = tester.widget<Text>(find.text('3'));

    expect(text.style?.color, textColor);
  });

  testWidgets('mostra correttamente nomi linea più lunghi', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      buildTestWidget(
        shortName: 'MEX',
        backgroundColor: const Color(0xFF191970),
        textColor: Colors.white,
      ),
    );

    expect(find.text('MEX'), findsOneWidget);
    expect(find.byType(FittedBox), findsOneWidget);
  });
}
