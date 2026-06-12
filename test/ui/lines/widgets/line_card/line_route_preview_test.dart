import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:jivaio/domain/models/transit_line.dart';
import 'package:jivaio/ui/lines/widgets/line_card/line_route_preview.dart';

void main() {
  const testLineColor = Color(0xFF0B7A55);

  const testDirection = TransitLineDirection(
    key: 'outbound',
    originName: 'Terminal Bus',
    destinationName: 'Università',
    stopCount: 8,
    upcomingDepartures: ['08:10', '08:40', '09:15'],
  );

  const testLine = TransitLine(
    routeId: 'line-1',
    shortName: '1',
    displayName: 'Linea 1',
    routeLongName: 'Terminal Bus - Università',
    routeColor: '0B7A55',
    directions: [
      testDirection,
      TransitLineDirection(
        key: 'return',
        originName: 'Università',
        destinationName: 'Terminal Bus',
        stopCount: 8,
        upcomingDepartures: ['10:00'],
      ),
    ],
  );

  Widget buildTestWidget({
    TransitLine line = testLine,
    TransitLineDirection direction = testDirection,
    bool canSwapDirection = true,
    VoidCallback? onSwapDirection,
    VoidCallback? onOpenDetails,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: LineRoutePreview(
            line: line,
            direction: direction,
            lineColor: testLineColor,
            canSwapDirection: canSwapDirection,
            onSwapDirection: onSwapDirection ?? () {},
            onOpenDetails: onOpenDetails ?? () {},
          ),
        ),
      ),
    );
  }

  testWidgets('mostra partenza, capolinea e titolo delle prossime partenze', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildTestWidget());

    expect(find.text('Partenza'), findsOneWidget);
    expect(find.text('Capolinea'), findsOneWidget);
    expect(find.text('Terminal Bus'), findsOneWidget);
    expect(find.text('Università'), findsOneWidget);
    expect(find.text('Prossime partenze'), findsOneWidget);
  });

  testWidgets('mostra gli orari delle prossime partenze', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildTestWidget());

    expect(find.text('08:10'), findsOneWidget);
    expect(find.text('08:40'), findsOneWidget);
    expect(find.text('09:15'), findsOneWidget);
  });

  testWidgets('mostra il bottone per aprire la linea completa', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildTestWidget());

    expect(find.text('Apri linea completa'), findsOneWidget);
    expect(find.byIcon(Icons.open_in_new_rounded), findsOneWidget);
  });

  testWidgets('esegue onOpenDetails quando si preme Apri linea completa', (
    WidgetTester tester,
  ) async {
    var opened = false;

    await tester.pumpWidget(
      buildTestWidget(
        onOpenDetails: () {
          opened = true;
        },
      ),
    );

    await tester.tap(find.text('Apri linea completa'));
    await tester.pump();

    expect(opened, isTrue);
  });

  testWidgets('mostra il bottone per invertire direzione quando consentito', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildTestWidget(canSwapDirection: true));

    expect(find.byIcon(Icons.swap_horiz_rounded), findsOneWidget);
    expect(find.byTooltip('Inverti direzione'), findsOneWidget);
  });

  testWidgets('esegue onSwapDirection quando si preme Inverti direzione', (
    WidgetTester tester,
  ) async {
    var swapped = false;

    await tester.pumpWidget(
      buildTestWidget(
        canSwapDirection: true,
        onSwapDirection: () {
          swapped = true;
        },
      ),
    );

    await tester.tap(find.byTooltip('Inverti direzione'));
    await tester.pump();

    expect(swapped, isTrue);
  });

  testWidgets('disabilita lo swap quando canSwapDirection è false', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildTestWidget(canSwapDirection: false));

    final iconButton = tester.widget<IconButton>(find.byType(IconButton));

    expect(find.byIcon(Icons.swap_horiz_rounded), findsOneWidget);
    expect(iconButton.onPressed, isNull);
  });

  testWidgets('mostra il messaggio vuoto quando non ci sono partenze', (
    WidgetTester tester,
  ) async {
    const directionWithoutDepartures = TransitLineDirection(
      key: 'outbound',
      originName: 'Terminal Bus',
      destinationName: 'Università',
      stopCount: 8,
      upcomingDepartures: [],
    );

    await tester.pumpWidget(
      buildTestWidget(direction: directionWithoutDepartures),
    );

    expect(
      find.text('Nessuna altra partenza disponibile per oggi.'),
      findsOneWidget,
    );
    expect(find.text('08:10'), findsNothing);
  });

  testWidgets(
    'mostra messaggio di nessun servizio quando la linea non è attiva oggi',
    (WidgetTester tester) async {
      const inactiveDirection = TransitLineDirection(
        key: 'outbound',
        originName: 'Terminal Bus',
        destinationName: 'Università',
        stopCount: 8,
        upcomingDepartures: [],
        hasServiceToday: false,
      );

      await tester.pumpWidget(buildTestWidget(direction: inactiveDirection));

      expect(find.text('Nessuna corsa attiva per oggi.'), findsOneWidget);
    },
  );

  testWidgets('mostra icona direzione unica per le linee unidirezionali', (
    WidgetTester tester,
  ) async {
    const oneWayLine = TransitLine(
      routeId: 'line-2u',
      shortName: '2U',
      displayName: 'Linea 2U',
      routeLongName: 'Linea universitaria',
      routeColor: '0B7A55',
      directions: [testDirection],
    );

    await tester.pumpWidget(
      buildTestWidget(line: oneWayLine, canSwapDirection: true),
    );

    final iconButton = tester.widget<IconButton>(find.byType(IconButton));

    expect(find.byIcon(Icons.arrow_forward_rounded), findsOneWidget);
    expect(iconButton.onPressed, isNull);
  });
}
