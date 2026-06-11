import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:jivaio/domain/models/transit_line.dart';
import 'package:jivaio/ui/lines/widgets/line_detail/line_detail_stop_tile.dart';

void main() {
  const testLineColor = Color(0xFF0B7A55);

  const testStop = TransitLineStop(
    stopId: 'stop-1',
    name: 'Terminal Bus',
    sequence: 1,
    officialTime: '08:10',
  );

  Widget buildTestWidget({
    TransitLineStop stop = testStop,
    bool isFirst = false,
    bool isLast = false,
    bool isSelected = false,
    bool isSelectionEnabled = true,
    VoidCallback? onTap,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: LineDetailStopTile(
              stop: stop,
              lineColor: testLineColor,
              isFirst: isFirst,
              isLast: isLast,
              isSelected: isSelected,
              isSelectionEnabled: isSelectionEnabled,
              onTap: onTap ?? () {},
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('mostra nome fermata e orario ufficiale',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      buildTestWidget(),
    );

    expect(find.text('Terminal Bus'), findsOneWidget);
    expect(find.text('Orario ufficiale'), findsOneWidget);
    expect(find.text('08:10'), findsOneWidget);
    expect(find.text('Orario stimato non disponibile'), findsOneWidget);
  });

  testWidgets('mostra fallback --:-- quando officialTime è null',
      (WidgetTester tester) async {
    const stopWithoutTime = TransitLineStop(
      stopId: 'stop-2',
      name: 'Fontana Luminosa',
      sequence: 2,
      officialTime: null,
    );

    await tester.pumpWidget(
      buildTestWidget(
        stop: stopWithoutTime,
      ),
    );

    expect(find.text('Fontana Luminosa'), findsOneWidget);
    expect(find.text('--:--'), findsOneWidget);
  });

  testWidgets('mostra fallback --:-- quando officialTime è vuoto',
      (WidgetTester tester) async {
    const stopWithEmptyTime = TransitLineStop(
      stopId: 'stop-3',
      name: 'Villa Comunale',
      sequence: 3,
      officialTime: '   ',
    );

    await tester.pumpWidget(
      buildTestWidget(
        stop: stopWithEmptyTime,
      ),
    );

    expect(find.text('Villa Comunale'), findsOneWidget);
    expect(find.text('--:--'), findsOneWidget);
  });

  testWidgets('mostra badge Partenza quando la fermata è la prima',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      buildTestWidget(
        isFirst: true,
      ),
    );

    expect(find.text('Partenza'), findsOneWidget);
    expect(find.text('Capolinea'), findsNothing);
  });

  testWidgets('mostra badge Capolinea quando la fermata è l’ultima',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      buildTestWidget(
        isLast: true,
      ),
    );

    expect(find.text('Capolinea'), findsOneWidget);
    expect(find.text('Partenza'), findsNothing);
  });

  testWidgets('mostra badge Selezionata quando la fermata è selezionata',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      buildTestWidget(
        isSelected: true,
      ),
    );

    expect(find.text('Selezionata'), findsOneWidget);
  });

  testWidgets('non mostra badge Selezionata quando la fermata non è selezionata',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      buildTestWidget(
        isSelected: false,
      ),
    );

    expect(find.text('Selezionata'), findsNothing);
  });

  testWidgets('esegue onTap quando la selezione è abilitata',
      (WidgetTester tester) async {
    var tapped = false;

    await tester.pumpWidget(
      buildTestWidget(
        isSelectionEnabled: true,
        onTap: () {
          tapped = true;
        },
      ),
    );

    await tester.tap(find.byType(InkWell));
    await tester.pump();

    expect(tapped, isTrue);
  });

  testWidgets('non esegue onTap quando la selezione è disabilitata',
      (WidgetTester tester) async {
    var tapped = false;

    await tester.pumpWidget(
      buildTestWidget(
        isSelectionEnabled: false,
        onTap: () {
          tapped = true;
        },
      ),
    );

    await tester.tap(find.byType(InkWell));
    await tester.pump();

    expect(tapped, isFalse);
  });

  testWidgets('usa AnimatedContainer per aggiornare lo stato visuale',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      buildTestWidget(),
    );

    expect(find.byType(AnimatedContainer), findsOneWidget);
  });
}