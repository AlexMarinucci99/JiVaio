import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jivaio/ui/home/widgets/route_search_card.dart';

void main() {
  late List<(String, String)> searches;
  setUp(() => searches = []);

  Future<void> mount(WidgetTester tester) => tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: RouteSearchCard(onSearch: (from, to) => searches.add((from, to))),
      ),
    ),
  );

  testWidgets(
    'richiede entrambi i campi non vuoti e si disabilita cancellandoli',
    (tester) async {
      await mount(tester);
      final button = find.widgetWithText(FilledButton, 'Cerca percorso');
      expect(tester.widget<FilledButton>(button).onPressed, isNull);
      await tester.enterText(find.byType(TextField).first, 'Terminal');
      await tester.enterText(find.byType(TextField).last, '   ');
      await tester.pump();
      expect(tester.widget<FilledButton>(button).onPressed, isNull);
      await tester.tap(button);
      expect(searches, isEmpty);
      await tester.enterText(find.byType(TextField).last, 'Ospedale');
      await tester.pump();
      expect(tester.widget<FilledButton>(button).onPressed, isNotNull);
      await tester.enterText(find.byType(TextField).first, '');
      await tester.pump();
      expect(tester.widget<FilledButton>(button).onPressed, isNull);
    },
  );

  testWidgets(
    'inverte i campi e invia i valori normalizzati nel nuovo ordine',
    (tester) async {
      await mount(tester);
      await tester.enterText(find.byType(TextField).first, ' Terminal ');
      await tester.enterText(find.byType(TextField).last, ' Ospedale ');
      await tester.pump();
      await tester.tap(find.byIcon(Icons.swap_vert_rounded));
      await tester.pump();
      final fields = tester
          .widgetList<TextField>(find.byType(TextField))
          .toList();
      expect(fields.first.controller!.text, ' Ospedale ');
      expect(fields.last.controller!.text, ' Terminal ');
      await tester.tap(find.text('Cerca percorso'));
      expect(searches, [('Ospedale', 'Terminal')]);
    },
  );

  testWidgets('swap con un solo campo mantiene la ricerca disabilitata', (
    tester,
  ) async {
    await mount(tester);
    await tester.enterText(find.byType(TextField).first, 'Terminal');
    await tester.pump();
    await tester.tap(find.byIcon(Icons.swap_vert_rounded));
    await tester.pump();
    expect(
      tester.widget<TextField>(find.byType(TextField).first).controller!.text,
      isEmpty,
    );
    expect(
      tester.widget<TextField>(find.byType(TextField).last).controller!.text,
      'Terminal',
    );
    expect(
      tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
      isNull,
    );
    expect(searches, isEmpty);
  });
}
