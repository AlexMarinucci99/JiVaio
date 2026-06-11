import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:jivaio/ui/lines/theme/line_card_colors.dart';
import 'package:jivaio/ui/lines/widgets/line_card/line_info_pill.dart';

void main() {
  Widget buildTestWidget({
    required IconData icon,
    required String label,
    LineCardPalette colors = LineCardColors.defaultPalette,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: LineInfoPill(
            icon: icon,
            label: label,
            colors: colors,
          ),
        ),
      ),
    );
  }

  testWidgets('mostra icona e testo della pill informativa',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      buildTestWidget(
        icon: Icons.schedule_rounded,
        label: 'Ogni 20 min',
      ),
    );

    expect(find.byIcon(Icons.schedule_rounded), findsOneWidget);
    expect(find.text('Ogni 20 min'), findsOneWidget);
  });

  testWidgets('usa una Row con dimensione minima', (WidgetTester tester) async {
    await tester.pumpWidget(
      buildTestWidget(
        icon: Icons.directions_bus_rounded,
        label: 'Linea urbana',
      ),
    );

    final row = tester.widget<Row>(find.byType(Row));

    expect(row.mainAxisSize, MainAxisSize.min);
  });

  testWidgets('applica i colori personalizzati alla pill',
      (WidgetTester tester) async {
    const customColors = LineCardPalette(
      pillBackground: Color(0xFFE8F5EE),
      border: Color(0xFF0B7A55),
      secondaryText: Color(0xFF191970),
    );

    await tester.pumpWidget(
      buildTestWidget(
        icon: Icons.info_outline_rounded,
        label: 'Attiva',
        colors: customColors,
      ),
    );

    final container = tester.widget<Container>(find.byType(Container));
    final decoration = container.decoration as BoxDecoration;

    final icon = tester.widget<Icon>(
      find.byIcon(Icons.info_outline_rounded),
    );

    final text = tester.widget<Text>(
      find.text('Attiva'),
    );

    expect(decoration.color, const Color(0xFFE8F5EE));
    expect(decoration.border, isNotNull);
    expect(icon.color, const Color(0xFF191970));
    expect(text.style?.color, const Color(0xFF191970));
  });

  testWidgets('mostra correttamente label più lunghe',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      buildTestWidget(
        icon: Icons.route_rounded,
        label: 'Terminal Bus → Università',
      ),
    );

    expect(find.text('Terminal Bus → Università'), findsOneWidget);
  });
}