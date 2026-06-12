import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:jivaio/ui/lines/view_model/line_detail_view_model.dart';
import 'package:jivaio/ui/lines/widgets/line_detail/line_detail_report_card.dart';

void main() {
  const testLineColor = Color(0xFF0B7A55);

  Widget buildTestWidget({
    LineDetailReportLocation? reportLocation,
    bool requiresStopSelection = false,
    bool canSendReport = false,
    String? selectedStopName,
    String? lastReportMessage,
    ValueChanged<LineDetailReportLocation>? onLocationChanged,
    ValueChanged<LineDetailReportType>? onReportPressed,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: LineDetailReportCard(
              lineColor: testLineColor,
              reportLocation: reportLocation,
              requiresStopSelection: requiresStopSelection,
              canSendReport: canSendReport,
              selectedStopName: selectedStopName,
              lastReportMessage: lastReportMessage,
              onLocationChanged: onLocationChanged ?? (_) {},
              onReportPressed: onReportPressed ?? (_) {},
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('mostra titolo e descrizione della sezione segnalazioni', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildTestWidget());

    expect(find.text('Segnalazioni'), findsOneWidget);
    expect(
      find.text(
        'Aiutaci a capire lo stato della corsa. Per ora la funzione è in modalità demo.',
      ),
      findsOneWidget,
    );
    expect(find.text('Sei sulla navetta?'), findsOneWidget);
  });

  testWidgets('mostra le due opzioni Sì e No', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());

    expect(find.text('Sì'), findsOneWidget);
    expect(find.text('No'), findsOneWidget);
    expect(find.byIcon(Icons.directions_bus_rounded), findsOneWidget);
    expect(find.byIcon(Icons.location_on_rounded), findsOneWidget);
  });

  testWidgets('esegue onLocationChanged con onBus quando si preme Sì', (
    WidgetTester tester,
  ) async {
    LineDetailReportLocation? selectedLocation;

    await tester.pumpWidget(
      buildTestWidget(
        onLocationChanged: (location) {
          selectedLocation = location;
        },
      ),
    );

    await tester.tap(find.text('Sì'));
    await tester.pump();

    expect(selectedLocation, LineDetailReportLocation.onBus);
  });

  testWidgets('esegue onLocationChanged con atStop quando si preme No', (
    WidgetTester tester,
  ) async {
    LineDetailReportLocation? selectedLocation;

    await tester.pumpWidget(
      buildTestWidget(
        onLocationChanged: (location) {
          selectedLocation = location;
        },
      ),
    );

    await tester.tap(find.text('No'));
    await tester.pump();

    expect(selectedLocation, LineDetailReportLocation.atStop);
  });

  testWidgets(
    'mostra istruzione iniziale quando non è stata scelta la posizione',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        buildTestWidget(reportLocation: null, canSendReport: false),
      );

      expect(find.text('Seleziona Sì o No per continuare.'), findsOneWidget);
    },
  );

  testWidgets('abilita le segnalazioni quando canSendReport è true', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      buildTestWidget(
        reportLocation: LineDetailReportLocation.onBus,
        canSendReport: true,
      ),
    );

    final delayButton = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Segnala ritardo'),
    );

    final crowdingButton = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Bus pieno'),
    );

    expect(delayButton.onPressed, isNotNull);
    expect(crowdingButton.onPressed, isNotNull);
    expect(
      find.textContaining('Puoi inviare una segnalazione'),
      findsOneWidget,
    );
  });

  testWidgets('disabilita le segnalazioni quando canSendReport è false', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildTestWidget(canSendReport: false));

    final delayButton = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Segnala ritardo'),
    );

    final crowdingButton = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Bus pieno'),
    );

    expect(delayButton.onPressed, isNull);
    expect(crowdingButton.onPressed, isNull);
  });

  testWidgets('richiede la selezione della fermata quando serve', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      buildTestWidget(
        reportLocation: LineDetailReportLocation.atStop,
        requiresStopSelection: true,
        selectedStopName: null,
        canSendReport: false,
      ),
    );

    expect(
      find.text(
        "Seleziona una fermata dall'elenco fermate prima di inviare la segnalazione.",
      ),
      findsOneWidget,
    );
  });

  testWidgets('mostra la fermata selezionata quando presente', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      buildTestWidget(
        reportLocation: LineDetailReportLocation.atStop,
        requiresStopSelection: true,
        selectedStopName: 'Fontana Luminosa',
        canSendReport: true,
      ),
    );

    expect(find.text('Fermata selezionata: Fontana Luminosa.'), findsOneWidget);
  });

  testWidgets(
    'esegue onReportPressed con delay quando si preme Segnala ritardo',
    (WidgetTester tester) async {
      LineDetailReportType? selectedReportType;

      await tester.pumpWidget(
        buildTestWidget(
          reportLocation: LineDetailReportLocation.onBus,
          canSendReport: true,
          onReportPressed: (type) {
            selectedReportType = type;
          },
        ),
      );

      await tester.tap(find.text('Segnala ritardo'));
      await tester.pump();

      expect(selectedReportType, LineDetailReportType.delay);
    },
  );

  testWidgets('esegue onReportPressed con crowding quando si preme Bus pieno', (
    WidgetTester tester,
  ) async {
    LineDetailReportType? selectedReportType;

    await tester.pumpWidget(
      buildTestWidget(
        reportLocation: LineDetailReportLocation.onBus,
        canSendReport: true,
        onReportPressed: (type) {
          selectedReportType = type;
        },
      ),
    );

    await tester.tap(find.text('Bus pieno'));
    await tester.pump();

    expect(selectedReportType, LineDetailReportType.crowding);
  });

  testWidgets(
    'non esegue onReportPressed quando i pulsanti sono disabilitati',
    (WidgetTester tester) async {
      LineDetailReportType? selectedReportType;

      await tester.pumpWidget(
        buildTestWidget(
          canSendReport: false,
          onReportPressed: (type) {
            selectedReportType = type;
          },
        ),
      );

      await tester.tap(find.text('Segnala ritardo'));
      await tester.pump();

      await tester.tap(find.text('Bus pieno'));
      await tester.pump();

      expect(selectedReportType, isNull);
    },
  );

  testWidgets('mostra il messaggio finale della segnalazione quando presente', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      buildTestWidget(
        reportLocation: LineDetailReportLocation.onBus,
        canSendReport: true,
        lastReportMessage: 'Ritardo registrato per la linea 1.',
      ),
    );

    expect(find.text('Ritardo registrato per la linea 1.'), findsOneWidget);
  });
}
