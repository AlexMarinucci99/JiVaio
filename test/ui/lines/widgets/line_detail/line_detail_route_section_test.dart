import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:jivaio/domain/models/transit_line.dart';
import 'package:jivaio/ui/lines/widgets/line_detail/line_detail_route_section.dart';
import 'package:jivaio/ui/lines/widgets/line_detail/line_detail_stop_tile.dart';

void main() {
  const testLineColor = Color(0xFF0B7A55);

  const testStops = [
    TransitLineStop(
      stopId: 'stop-1',
      name: 'Terminal Bus',
      sequence: 1,
      officialTime: '08:10',
    ),
    TransitLineStop(
      stopId: 'stop-2',
      name: 'Fontana Luminosa',
      sequence: 2,
      officialTime: '08:18',
    ),
    TransitLineStop(
      stopId: 'stop-3',
      name: 'Università',
      sequence: 3,
      officialTime: '08:32',
    ),
  ];

  Widget buildTestWidget({
    List<TransitLineStop> stops = testStops,
    String? selectedStopId,
    bool isStopSelectionEnabled = false,
    ValueChanged<String>? onStopSelected,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: LineDetailRouteSection(
              stops: stops,
              lineColor: testLineColor,
              selectedStopId: selectedStopId,
              isStopSelectionEnabled: isStopSelectionEnabled,
              onStopSelected: onStopSelected ?? (_) {},
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('mostra titolo e descrizione della sezione', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildTestWidget(isStopSelectionEnabled: false));

    expect(find.text('Elenco fermate'), findsOneWidget);
    expect(
      find.text('Fermate ordinate della tratta selezionata.'),
      findsOneWidget,
    );
  });

  testWidgets('mantiene la descrizione unica quando la selezione è abilitata', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildTestWidget(isStopSelectionEnabled: true));

    expect(
      find.text('Fermate ordinate della tratta selezionata.'),
      findsOneWidget,
    );

    expect(
      find.text('Seleziona la fermata da cui vuoi inviare la segnalazione.'),
      findsNothing,
    );
  });

  testWidgets('mostra una tile per ogni fermata', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());

    expect(find.byType(LineDetailStopTile), findsNWidgets(3));

    expect(find.text('Terminal Bus'), findsOneWidget);
    expect(find.text('Fontana Luminosa'), findsOneWidget);
    expect(find.text('Università'), findsOneWidget);
  });

  testWidgets('mostra gli orari ufficiali delle fermate', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildTestWidget());

    expect(find.text('08:10'), findsOneWidget);
    expect(find.text('08:18'), findsOneWidget);
    expect(find.text('08:32'), findsOneWidget);
  });

  testWidgets(
    'marca la prima fermata come Partenza e l’ultima come Capolinea',
    (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.text('Partenza'), findsOneWidget);
      expect(find.text('Capolinea'), findsOneWidget);
    },
  );

  testWidgets('mostra la fermata selezionata', (WidgetTester tester) async {
    await tester.pumpWidget(
      buildTestWidget(selectedStopId: 'stop-2', isStopSelectionEnabled: true),
    );

    expect(find.text('Selezionata'), findsOneWidget);
    expect(find.text('Fontana Luminosa'), findsOneWidget);
  });

  testWidgets(
    'esegue onStopSelected con lo stopId corretto quando la selezione è abilitata',
    (WidgetTester tester) async {
      String? selectedStopId;

      await tester.pumpWidget(
        buildTestWidget(
          isStopSelectionEnabled: true,
          onStopSelected: (stopId) {
            selectedStopId = stopId;
          },
        ),
      );

      await tester.tap(find.text('Fontana Luminosa'));
      await tester.pump();

      expect(selectedStopId, 'stop-2');
    },
  );

  testWidgets('non esegue onStopSelected quando la selezione è disabilitata', (
    WidgetTester tester,
  ) async {
    String? selectedStopId;

    await tester.pumpWidget(
      buildTestWidget(
        isStopSelectionEnabled: false,
        onStopSelected: (stopId) {
          selectedStopId = stopId;
        },
      ),
    );

    await tester.tap(find.text('Fontana Luminosa'));
    await tester.pump();

    expect(selectedStopId, isNull);
  });

  testWidgets('mostra messaggio vuoto quando non ci sono fermate', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildTestWidget(stops: const []));

    expect(find.byType(LineDetailStopTile), findsNothing);
    expect(
      find.text('Fermate non disponibili per questa direzione.'),
      findsOneWidget,
    );
  });
}
