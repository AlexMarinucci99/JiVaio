import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:jivaio/domain/models/transit_line.dart';
import 'package:jivaio/ui/lines/widgets/line_card/line_badge.dart';
import 'package:jivaio/ui/lines/widgets/line_card/line_card_header.dart';
import 'package:jivaio/ui/lines/widgets/line_card/line_info_pill.dart';
import 'package:jivaio/ui/lines/widgets/line_card/line_save_button.dart';

void main() {
  const testDirection = TransitLineDirection(
    key: 'outbound',
    originName: 'Terminal Bus',
    destinationName: 'Università',
    stopCount: 8,
    upcomingDepartures: ['08:10', '08:40'],
  );

  const testLine = TransitLine(
    routeId: 'line-1',
    shortName: '1',
    displayName: 'Linea 1',
    routeLongName: 'Terminal Bus - Università',
    routeColor: '0B7A55',
    directions: [testDirection],
  );

  Widget buildTestWidget({
    TransitLine line = testLine,
    TransitLineDirection direction = testDirection,
    bool isSaved = false,
    VoidCallback? onToggleSaved,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: LineCardHeader(
            line: line,
            direction: direction,
            isSaved: isSaved,
            onToggleSaved: onToggleSaved ?? () {},
          ),
        ),
      ),
    );
  }

  testWidgets('mostra numero linea, nome e descrizione', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildTestWidget());

    expect(find.text('1'), findsOneWidget);
    expect(find.text('Linea 1'), findsOneWidget);
    expect(find.text('Terminal Bus - Università'), findsOneWidget);
  });

  testWidgets('mostra badge, pill informativa e bottone salva', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildTestWidget());

    expect(find.byType(LineBadge), findsOneWidget);
    expect(find.byType(LineInfoPill), findsOneWidget);
    expect(find.byType(LineSaveButton), findsOneWidget);
  });

  testWidgets('mostra il numero corretto di fermate al plurale', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildTestWidget());

    expect(find.text('8 fermate'), findsOneWidget);
    expect(find.byIcon(Icons.place_rounded), findsOneWidget);
  });

  testWidgets('mostra il numero corretto di fermate al singolare', (
    WidgetTester tester,
  ) async {
    const singleStopDirection = TransitLineDirection(
      key: 'outbound',
      originName: 'Terminal Bus',
      destinationName: 'Università',
      stopCount: 1,
      upcomingDepartures: ['08:10'],
    );

    await tester.pumpWidget(buildTestWidget(direction: singleStopDirection));

    expect(find.text('1 fermata'), findsOneWidget);
  });

  testWidgets('mostra cuore vuoto quando la linea non è salvata', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildTestWidget(isSaved: false));

    expect(find.byIcon(Icons.favorite_border_rounded), findsOneWidget);
    expect(find.byIcon(Icons.favorite_rounded), findsNothing);
    expect(find.byTooltip('Salva linea'), findsOneWidget);
  });

  testWidgets('mostra cuore pieno quando la linea è salvata', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildTestWidget(isSaved: true));

    expect(find.byIcon(Icons.favorite_rounded), findsOneWidget);
    expect(find.byIcon(Icons.favorite_border_rounded), findsNothing);
    expect(find.byTooltip('Rimuovi dai salvati'), findsOneWidget);
  });

  testWidgets('esegue onToggleSaved quando si preme il bottone salva', (
    WidgetTester tester,
  ) async {
    var toggled = false;

    await tester.pumpWidget(
      buildTestWidget(
        isSaved: false,
        onToggleSaved: () {
          toggled = true;
        },
      ),
    );

    await tester.tap(find.byTooltip('Salva linea'));
    await tester.pump();

    expect(toggled, isTrue);
  });

  testWidgets('usa layout orizzontale con contenuto principale espanso', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildTestWidget());

    expect(find.byType(Row), findsWidgets);
    expect(find.byType(Expanded), findsOneWidget);
  });
}
