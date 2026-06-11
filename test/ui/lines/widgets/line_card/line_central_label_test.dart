import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:jivaio/ui/lines/theme/line_card_colors.dart';
import 'package:jivaio/ui/lines/widgets/line_card/line_central_label.dart';

void main() {
  Widget buildTestWidget({
    required String caption,
    required String value,
    required CrossAxisAlignment crossAxisAlignment,
    LineCardPalette colors = LineCardColors.defaultPalette,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: LineCentralLabel(
            caption: caption,
            value: value,
            crossAxisAlignment: crossAxisAlignment,
            colors: colors,
          ),
        ),
      ),
    );
  }

  testWidgets('mostra caption e valore della label centrale',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      buildTestWidget(
        caption: 'Partenza',
        value: 'Terminal Bus',
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
    );

    expect(find.text('Partenza'), findsOneWidget);
    expect(find.text('Terminal Bus'), findsOneWidget);
  });

  testWidgets('usa l’allineamento passato al widget',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      buildTestWidget(
        caption: 'Capolinea',
        value: 'Università',
        crossAxisAlignment: CrossAxisAlignment.end,
      ),
    );

    final column = tester.widget<Column>(find.byType(Column));

    expect(column.crossAxisAlignment, CrossAxisAlignment.end);
  });

  testWidgets('allinea il testo del valore a destra quando crossAxisAlignment è end',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      buildTestWidget(
        caption: 'Capolinea',
        value: 'Università',
        crossAxisAlignment: CrossAxisAlignment.end,
      ),
    );

    final valueText = tester.widget<Text>(find.text('Università'));

    expect(valueText.textAlign, TextAlign.end);
  });

  testWidgets('allinea il testo del valore a sinistra quando crossAxisAlignment è start',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      buildTestWidget(
        caption: 'Partenza',
        value: 'Terminal Bus',
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
    );

    final valueText = tester.widget<Text>(find.text('Terminal Bus'));

    expect(valueText.textAlign, TextAlign.start);
  });

  testWidgets('applica i colori personalizzati a caption e valore',
      (WidgetTester tester) async {
    const customColors = LineCardPalette(
      labelAccent: Color(0xFF0B7A55),
      primaryText: Color(0xFF191970),
    );

    await tester.pumpWidget(
      buildTestWidget(
        caption: 'Partenza',
        value: 'Terminal Bus',
        crossAxisAlignment: CrossAxisAlignment.start,
        colors: customColors,
      ),
    );

    final captionText = tester.widget<Text>(find.text('Partenza'));
    final valueText = tester.widget<Text>(find.text('Terminal Bus'));

    expect(captionText.style?.color, const Color(0xFF0B7A55));
    expect(valueText.style?.color, const Color(0xFF191970));
  });

  testWidgets('limita il valore a una sola riga con ellissi',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      buildTestWidget(
        caption: 'Partenza',
        value: 'Nome fermata molto lungo da troncare graficamente',
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
    );

    final valueText = tester.widget<Text>(
      find.text('Nome fermata molto lungo da troncare graficamente'),
    );

    expect(valueText.maxLines, 1);
    expect(valueText.overflow, TextOverflow.ellipsis);
  });
}