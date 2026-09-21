import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jivaio/domain/models/transit_line.dart';
import 'package:jivaio/ui/lines/widgets/line_card/line_card.dart';
import 'package:jivaio/ui/lines/widgets/line_card/line_central_label.dart';

import '../../helpers/transit_fakes.dart';

void main() {
  testWidgets(
    'swap aggiorna partenza, capolinea e orari senza aprire il dettaglio',
    (tester) async {
      var opened = 0;
      var saved = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LineCard(
              line: testLine,
              isSaved: false,
              onToggleSaved: () => saved++,
              onOpenDetails: () => opened++,
            ),
          ),
        ),
      );
      String origin() => tester
          .widgetList<LineCentralLabel>(find.byType(LineCentralLabel))
          .singleWhere((label) => label.caption == 'Partenza')
          .value;
      expect(origin(), 'Terminal');
      expect(find.text('08:10'), findsOneWidget);
      await tester.tap(find.byTooltip('Inverti direzione'));
      await tester.pump();
      expect(origin(), 'Ospedale');
      expect(find.text('09:20'), findsOneWidget);
      expect(find.text('08:10'), findsNothing);
      expect(opened, 0);
      expect(saved, 0);
      await tester.tap(find.byTooltip('Inverti direzione'));
      await tester.pump();
      expect(origin(), 'Terminal');
      await tester.tap(find.text('Apri linea completa'));
      expect(opened, 1);
      await tester.tap(find.byTooltip('Salva linea'));
      expect(saved, 1);
      expect(opened, 1);
    },
  );

  for (final hasService in [true, false]) {
    testWidgets('direzione unica e partenze vuote con servizio $hasService', (
      tester,
    ) async {
      final line = TransitLine(
        routeId: 'single',
        shortName: '2UT',
        displayName: 'Linea unica',
        directions: [
          TransitLineDirection(
            key: '0',
            originName: 'A',
            destinationName: 'B',
            upcomingDepartures: [],
            hasServiceToday: hasService,
          ),
          testLine.directions.last,
        ],
      );
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LineCard(
              line: line,
              isSaved: true,
              onToggleSaved: () {},
              onOpenDetails: () {},
            ),
          ),
        ),
      );
      expect(
        tester
            .widget<IconButton>(
              find.byWidgetPredicate(
                (widget) =>
                    widget is IconButton && widget.tooltip == 'Direzione unica',
              ),
            )
            .onPressed,
        isNull,
      );
      expect(find.byTooltip('Rimuovi dai salvati'), findsOneWidget);
      expect(
        find.text(
          hasService
              ? 'Nessuna altra partenza disponibile per oggi.'
              : 'Nessuna corsa attiva per oggi.',
        ),
        findsOneWidget,
      );
    });
  }
}
