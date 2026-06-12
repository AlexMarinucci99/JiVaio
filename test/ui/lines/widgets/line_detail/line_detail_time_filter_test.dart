import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:jivaio/ui/lines/widgets/line_detail/line_detail_time_filter.dart';

void main() {
  Widget buildDirectSheet({
    String currentRangeLabel = '08:00 - 09:00',
    bool isAutomaticSelected = true,
    int? selectedManualHour,
    List<int> manualHours = const [8, 9, 10],
  }) {
    return MaterialApp(
      home: Scaffold(
        body: LineDetailTimeFilterSheet(
          currentRangeLabel: currentRangeLabel,
          isAutomaticSelected: isAutomaticSelected,
          selectedManualHour: selectedManualHour,
          manualHours: manualHours,
        ),
      ),
    );
  }

  Widget buildModalHost({
    String currentRangeLabel = '08:00 - 09:00',
    bool isAutomaticSelected = true,
    int? selectedManualHour,
    List<int> manualHours = const [8, 9, 10],
    required ValueChanged<LineDetailTimeSelection?> onResult,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () async {
                  final result = await showLineDetailTimeFilterSheet(
                    context,
                    currentRangeLabel: currentRangeLabel,
                    isAutomaticSelected: isAutomaticSelected,
                    selectedManualHour: selectedManualHour,
                    manualHours: manualHours,
                  );

                  onResult(result);
                },
                child: const Text('Apri filtro'),
              );
            },
          ),
        ),
      ),
    );
  }

  testWidgets('mostra titolo e descrizione del filtro fascia oraria', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildDirectSheet());

    expect(find.text('Seleziona fascia oraria'), findsOneWidget);
    expect(
      find.text(
        "Scegli Automatico per usare l'ora locale del dispositivo "
        'oppure seleziona una fascia manualmente.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('mostra opzione Automatico con fascia attuale', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      buildDirectSheet(currentRangeLabel: '14:00 - 15:00'),
    );

    expect(find.text('Automatico'), findsOneWidget);
    expect(
      find.text(
        "Usa l'ora locale del dispositivo. Fascia attuale: 14:00 - 15:00",
      ),
      findsOneWidget,
    );
  });

  testWidgets('mostra le fasce orarie manuali ricevute', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildDirectSheet(manualHours: const [7, 8, 13]));

    expect(find.text('Selezione manuale'), findsOneWidget);
    expect(find.text('07:00 - 08:00'), findsOneWidget);
    expect(find.text('08:00 - 09:00'), findsOneWidget);

    await tester.scrollUntilVisible(find.text('13:00 - 14:00'), 250);

    await tester.pump();

    expect(find.text('13:00 - 14:00'), findsOneWidget);
  });

  testWidgets('mostra i bottoni Annulla e Conferma', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildDirectSheet());

    expect(find.text('Annulla'), findsOneWidget);
    expect(find.text('Conferma'), findsOneWidget);
  });

  testWidgets('mostra la spunta sulla modalità automatica quando selezionata', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildDirectSheet(isAutomaticSelected: true));

    expect(find.byIcon(Icons.check_rounded), findsOneWidget);
  });

  testWidgets('mostra la spunta sulla fascia manuale selezionata', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      buildDirectSheet(
        isAutomaticSelected: false,
        selectedManualHour: 9,
        manualHours: const [8, 9, 10],
      ),
    );

    expect(find.byIcon(Icons.check_rounded), findsOneWidget);
    expect(find.text('09:00 - 10:00'), findsOneWidget);
  });

  testWidgets(
    'restituisce selezione automatica quando si conferma Automatico',
    (WidgetTester tester) async {
      LineDetailTimeSelection? selectedResult;

      await tester.pumpWidget(
        buildModalHost(
          isAutomaticSelected: true,
          onResult: (result) {
            selectedResult = result;
          },
        ),
      );

      await tester.tap(find.text('Apri filtro'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Conferma'));
      await tester.pumpAndSettle();

      expect(selectedResult, isNotNull);
      expect(selectedResult!.isAutomatic, isTrue);
      expect(selectedResult!.hour, isNull);
    },
  );

  testWidgets(
    'restituisce fascia manuale quando viene selezionata e confermata',
    (WidgetTester tester) async {
      LineDetailTimeSelection? selectedResult;

      await tester.pumpWidget(
        buildModalHost(
          isAutomaticSelected: true,
          manualHours: const [8, 9, 10],
          onResult: (result) {
            selectedResult = result;
          },
        ),
      );

      await tester.tap(find.text('Apri filtro'));
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(find.text('10:00 - 11:00'), 250);

      await tester.pumpAndSettle();

      await tester.tap(find.text('10:00 - 11:00'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Conferma'));
      await tester.pumpAndSettle();

      expect(selectedResult, isNotNull);
      expect(selectedResult!.isAutomatic, isFalse);
      expect(selectedResult!.hour, 10);
    },
  );

  testWidgets('restituisce null quando viene premuto Annulla', (
    WidgetTester tester,
  ) async {
    var resultWasReceived = false;
    LineDetailTimeSelection? selectedResult;

    await tester.pumpWidget(
      buildModalHost(
        onResult: (result) {
          resultWasReceived = true;
          selectedResult = result;
        },
      ),
    );

    await tester.tap(find.text('Apri filtro'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Annulla'));
    await tester.pumpAndSettle();

    expect(resultWasReceived, isTrue);
    expect(selectedResult, isNull);
  });

  testWidgets('permette di tornare da manuale ad Automatico', (
    WidgetTester tester,
  ) async {
    LineDetailTimeSelection? selectedResult;

    await tester.pumpWidget(
      buildModalHost(
        isAutomaticSelected: false,
        selectedManualHour: 9,
        manualHours: const [8, 9, 10],
        onResult: (result) {
          selectedResult = result;
        },
      ),
    );

    await tester.tap(find.text('Apri filtro'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Automatico'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Conferma'));
    await tester.pumpAndSettle();

    expect(selectedResult, isNotNull);
    expect(selectedResult!.isAutomatic, isTrue);
    expect(selectedResult!.hour, isNull);
  });
}
