import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:jivaio/domain/models/transit_line.dart';
import 'package:jivaio/ui/lines/widgets/line_detail/line_detail_header.dart';

const testDirection = TransitLineDirection(
  key: 'outbound',
  originName: 'Terminal Bus',
  destinationName: 'Università',
  stopCount: 4,
  upcomingDepartures: ['08:10', '08:25'],
);

const testSingleStopDirection = TransitLineDirection(
  key: 'single',
  originName: 'Centro',
  destinationName: 'Stazione',
  stopCount: 1,
  upcomingDepartures: ['09:00'],
);

const testLine = TransitLine(
  routeId: 'line-1',
  shortName: '1',
  displayName: 'Linea 1',
  routeLongName: 'Terminal Bus - Università',
  routeColor: '0B7A55',
  directions: [
    testDirection,
  ],
);

const testUnidirectionalLine = TransitLine(
  routeId: 'line-2u',
  shortName: '2U',
  displayName: 'Linea 2U',
  routeLongName: 'Direzione unica',
  routeColor: '2563EB',
  directions: [
    testDirection,
  ],
);

void main() {
  Widget buildTestWidget({
    TransitLine line = testLine,
    TransitLineDirection? direction = testDirection,
    bool canSwapDirection = true,
    VoidCallback? onSwapDirection,
    VoidCallback? onClose,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: LineDetailHeader(
              line: line,
              direction: direction,
              lineColor: const Color(0xFF0B7A55),
              canSwapDirection: canSwapDirection,
              onSwapDirection: onSwapDirection ?? () {},
              onClose: onClose ?? () {},
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('mostra le informazioni principali della linea',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      buildTestWidget(),
    );

    expect(find.text('1'), findsOneWidget);
    expect(find.text('Linea 1'), findsOneWidget);
    expect(find.text('Terminal Bus - Università'), findsOneWidget);
    expect(find.text('4 fermate'), findsOneWidget);
    expect(find.text('Partenza'), findsOneWidget);
    expect(find.text('Terminal Bus'), findsOneWidget);
    expect(find.text('Capolinea'), findsOneWidget);
    expect(find.text('Università'), findsOneWidget);
  });

  testWidgets('mostra il testo singolare quando la direzione ha una sola fermata',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      buildTestWidget(
        direction: testSingleStopDirection,
      ),
    );

    expect(find.text('1 fermata'), findsOneWidget);
  });

  testWidgets('esegue onClose quando viene premuto il bottone indietro',
      (WidgetTester tester) async {
    var closeCalled = false;

    await tester.pumpWidget(
      buildTestWidget(
        onClose: () {
          closeCalled = true;
        },
      ),
    );

    await tester.tap(find.byTooltip('Torna alle linee'));
    await tester.pump();

    expect(closeCalled, isTrue);
  });

  testWidgets('esegue onSwapDirection quando il cambio direzione è disponibile',
      (WidgetTester tester) async {
    var swapCalled = false;

    await tester.pumpWidget(
      buildTestWidget(
        canSwapDirection: true,
        onSwapDirection: () {
          swapCalled = true;
        },
      ),
    );

    await tester.tap(find.byTooltip('Inverti direzione'));
    await tester.pump();

    expect(swapCalled, isTrue);
  });

  testWidgets('non esegue onSwapDirection quando canSwapDirection è false',
      (WidgetTester tester) async {
    var swapCalled = false;

    await tester.pumpWidget(
      buildTestWidget(
        canSwapDirection: false,
        onSwapDirection: () {
          swapCalled = true;
        },
      ),
    );

    expect(find.byType(IconButton), findsAtLeastNWidgets(2));

    await tester.tap(find.byType(IconButton).last);
    await tester.pump();

    expect(swapCalled, isFalse);
  });

  testWidgets('non esegue onSwapDirection per una linea a direzione unica',
      (WidgetTester tester) async {
    var swapCalled = false;

    await tester.pumpWidget(
      buildTestWidget(
        line: testUnidirectionalLine,
        canSwapDirection: true,
        onSwapDirection: () {
          swapCalled = true;
        },
      ),
    );

    expect(find.text('Linea 2U'), findsOneWidget);
    expect(find.byType(IconButton), findsAtLeastNWidgets(2));

    await tester.tap(find.byType(IconButton).last);
    await tester.pump();

    expect(swapCalled, isFalse);
  });

  testWidgets('mostra messaggio quando la direzione non è disponibile',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      buildTestWidget(
        direction: null,
      ),
    );

    expect(find.text('Direzione non disponibile'), findsOneWidget);
    expect(find.text('Partenza'), findsNothing);
    expect(find.text('Capolinea'), findsNothing);
  });
}