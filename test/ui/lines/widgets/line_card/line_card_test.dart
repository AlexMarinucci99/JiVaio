import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:jivaio/domain/models/transit_line.dart';
import 'package:jivaio/ui/lines/widgets/line_card/line_card.dart';
import 'package:jivaio/ui/lines/widgets/line_card/line_card_header.dart';
import 'package:jivaio/ui/lines/widgets/line_card/line_route_preview.dart';

void main() {
  const outboundDirection = TransitLineDirection(
    key: 'outbound',
    originName: 'Terminal Bus',
    destinationName: 'Università',
    stopCount: 8,
    upcomingDepartures: ['08:10', '08:40', '09:15'],
  );

  const returnDirection = TransitLineDirection(
    key: 'return',
    originName: 'Università',
    destinationName: 'Terminal Bus',
    stopCount: 8,
    upcomingDepartures: ['10:00', '10:30'],
  );

  const testLine = TransitLine(
    routeId: 'line-1',
    shortName: '1',
    displayName: 'Linea 1',
    routeLongName: 'Terminal Bus - Università',
    routeColor: '0B7A55',
    directions: [
      outboundDirection,
      returnDirection,
    ],
  );

  Widget buildTestWidget({
    TransitLine line = testLine,
    bool isSaved = false,
    VoidCallback? onToggleSaved,
    VoidCallback? onOpenDetails,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: LineCard(
            line: line,
            isSaved: isSaved,
            onToggleSaved: onToggleSaved ?? () {},
            onOpenDetails: onOpenDetails ?? () {},
          ),
        ),
      ),
    );
  }

  testWidgets('compone header e preview della linea',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      buildTestWidget(),
    );

    expect(find.byType(LineCardHeader), findsOneWidget);
    expect(find.byType(LineRoutePreview), findsOneWidget);
  });

  testWidgets('mostra le informazioni principali della linea',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      buildTestWidget(),
    );

    expect(find.text('1'), findsOneWidget);
    expect(find.text('Linea 1'), findsOneWidget);
    expect(find.text('Terminal Bus - Università'), findsOneWidget);
    expect(find.text('8 fermate'), findsOneWidget);
  });

  testWidgets('mostra la direzione iniziale e le sue prossime partenze',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      buildTestWidget(),
    );

    expect(find.text('Partenza'), findsOneWidget);
    expect(find.text('Capolinea'), findsOneWidget);
    expect(find.text('Prossime partenze'), findsOneWidget);

    expect(find.text('08:10'), findsOneWidget);
    expect(find.text('08:40'), findsOneWidget);
    expect(find.text('09:15'), findsOneWidget);

    expect(find.text('10:00'), findsNothing);
    expect(find.text('10:30'), findsNothing);
  });

  testWidgets('esegue onToggleSaved quando viene premuto il bottone salva',
      (WidgetTester tester) async {
    var savedToggled = false;

    await tester.pumpWidget(
      buildTestWidget(
        isSaved: false,
        onToggleSaved: () {
          savedToggled = true;
        },
      ),
    );

    await tester.tap(find.byTooltip('Salva linea'));
    await tester.pump();

    expect(savedToggled, isTrue);
  });

  testWidgets('mostra stato salvato quando isSaved è true',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      buildTestWidget(
        isSaved: true,
      ),
    );

    expect(find.byIcon(Icons.favorite_rounded), findsOneWidget);
    expect(find.byTooltip('Rimuovi dai salvati'), findsOneWidget);
  });

  testWidgets('esegue onOpenDetails quando viene premuto Apri linea completa',
      (WidgetTester tester) async {
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

  testWidgets('inverte la direzione quando viene premuto il bottone swap',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      buildTestWidget(),
    );

    expect(find.text('08:10'), findsOneWidget);
    expect(find.text('10:00'), findsNothing);

    await tester.tap(find.byTooltip('Inverti direzione'));
    await tester.pump();

    expect(find.text('10:00'), findsOneWidget);
    expect(find.text('10:30'), findsOneWidget);

    expect(find.text('08:10'), findsNothing);
    expect(find.text('08:40'), findsNothing);
    expect(find.text('09:15'), findsNothing);
  });

  testWidgets('non mostra il tooltip di swap attivo se la linea ha una sola direzione',
      (WidgetTester tester) async {
    const singleDirectionLine = TransitLine(
      routeId: 'line-single',
      shortName: '3',
      displayName: 'Linea 3',
      routeLongName: 'Terminal Bus - Centro',
      routeColor: '0B7A55',
      directions: [
        TransitLineDirection(
          key: 'outbound',
          originName: 'Terminal Bus',
          destinationName: 'Centro',
          stopCount: 5,
          upcomingDepartures: ['11:00'],
        ),
      ],
    );

    await tester.pumpWidget(
      buildTestWidget(
        line: singleDirectionLine,
      ),
    );

    expect(find.byTooltip('Inverti direzione'), findsNothing);
    expect(find.byTooltip('Direzione unica'), findsOneWidget);
    expect(find.text('11:00'), findsOneWidget);
  });

  testWidgets('mostra messaggio vuoto quando la direzione non ha partenze',
      (WidgetTester tester) async {
    const lineWithoutDepartures = TransitLine(
      routeId: 'line-empty',
      shortName: '4',
      displayName: 'Linea 4',
      routeLongName: 'Terminal Bus - Ospedale',
      routeColor: '0B7A55',
      directions: [
        TransitLineDirection(
          key: 'outbound',
          originName: 'Terminal Bus',
          destinationName: 'Ospedale',
          stopCount: 6,
          upcomingDepartures: [],
        ),
      ],
    );

    await tester.pumpWidget(
      buildTestWidget(
        line: lineWithoutDepartures,
      ),
    );

    expect(
      find.text('Nessuna altra partenza disponibile per oggi.'),
      findsOneWidget,
    );
  });
}