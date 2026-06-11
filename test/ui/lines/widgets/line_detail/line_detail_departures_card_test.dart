import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:jivaio/domain/models/transit_line.dart';
import 'package:jivaio/ui/lines/widgets/line_detail/line_detail_departures_card.dart';

void main() {
  const testDepartures = [
    TransitLineDeparture(
      tripId: 'trip-1',
      departureTime: '08:10',
    ),
    TransitLineDeparture(
      tripId: 'trip-2',
      departureTime: '08:40',
    ),
    TransitLineDeparture(
      tripId: 'trip-3',
      departureTime: '09:15',
    ),
  ];

  Widget buildTestWidget({
    String selectedTimeRange = '08:00 - 09:00',
    List<TransitLineDeparture> departures = testDepartures,
    String? selectedTripId = 'trip-1',
    bool isLoading = false,
    String emptyMessage = 'Non ci sono bus in questa fascia oraria.',
    VoidCallback? onSelectTimeRange,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: LineDetailDeparturesCard(
              selectedTimeRange: selectedTimeRange,
              departures: departures,
              selectedTripId: selectedTripId,
              isLoading: isLoading,
              emptyMessage: emptyMessage,
              onSelectTimeRange: onSelectTimeRange ?? () {},
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('mostra titolo, fascia oraria e sezione corse disponibili',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      buildTestWidget(),
    );

    expect(find.text('Prossime partenze'), findsOneWidget);
    expect(find.text('Fascia oraria'), findsOneWidget);
    expect(find.text('08:00 - 09:00'), findsOneWidget);
    expect(find.text('Corse disponibili'), findsOneWidget);
  });

  testWidgets('mostra le icone del selettore fascia oraria',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      buildTestWidget(),
    );

    expect(find.byIcon(Icons.access_time_rounded), findsOneWidget);
    expect(find.byIcon(Icons.keyboard_arrow_down_rounded), findsOneWidget);
  });

  testWidgets('mostra gli orari delle corse disponibili',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      buildTestWidget(),
    );

    expect(find.text('08:10'), findsOneWidget);
    expect(find.text('08:40'), findsOneWidget);
    expect(find.text('09:15'), findsOneWidget);
  });

  testWidgets('esegue onSelectTimeRange quando viene premuta la fascia oraria',
      (WidgetTester tester) async {
    var filterOpened = false;

    await tester.pumpWidget(
      buildTestWidget(
        onSelectTimeRange: () {
          filterOpened = true;
        },
      ),
    );

    await tester.tap(find.text('08:00 - 09:00'));
    await tester.pump();

    expect(filterOpened, isTrue);
  });

  testWidgets('mostra loader quando isLoading è true',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      buildTestWidget(
        isLoading: true,
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    expect(find.text('08:10'), findsNothing);
    expect(find.text('08:40'), findsNothing);
    expect(find.text('09:15'), findsNothing);
    expect(find.text('Non ci sono bus in questa fascia oraria.'), findsNothing);
  });

  testWidgets('mostra messaggio vuoto quando non ci sono corse',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      buildTestWidget(
        departures: const [],
        selectedTripId: null,
        emptyMessage: 'Non ci sono bus in questa fascia oraria.',
      ),
    );

    expect(
      find.text('Non ci sono bus in questa fascia oraria.'),
      findsOneWidget,
    );

    expect(find.text('08:10'), findsNothing);
    expect(find.text('08:40'), findsNothing);
    expect(find.text('09:15'), findsNothing);
  });

  testWidgets('mostra messaggio di nessun servizio quando passato dal chiamante',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      buildTestWidget(
        departures: const [],
        selectedTripId: null,
        emptyMessage: 'Nessuna corsa attiva per oggi.',
      ),
    );

    expect(find.text('Nessuna corsa attiva per oggi.'), findsOneWidget);
  });

  testWidgets('aggiorna il testo della fascia oraria ricevuta',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      buildTestWidget(
        selectedTimeRange: '14:00 - 15:00',
      ),
    );

    expect(find.text('14:00 - 15:00'), findsOneWidget);
    expect(find.text('08:00 - 09:00'), findsNothing);
  });
}