import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:jivaio/ui/home/widgets/route_search_card.dart';

void main() {
  Widget buildTestWidget({void Function(String from, String to)? onSearch}) {
    return MaterialApp(
      home: Scaffold(
        body: Center(child: RouteSearchCard(onSearch: onSearch)),
      ),
    );
  }

  testWidgets('mostra i campi di partenza e destinazione', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildTestWidget());

    expect(find.text('Da'), findsOneWidget);
    expect(find.text('A'), findsOneWidget);
    expect(find.text('Cerca percorso'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(2));

    final fields = find.byType(TextField);
    final fromField = tester.widget<TextField>(fields.at(0));
    final toField = tester.widget<TextField>(fields.at(1));

    expect(fromField.controller?.text, isEmpty);
    expect(fromField.decoration?.hintText, 'Da dove vuoi partire?');

    expect(toField.controller?.text, isEmpty);
    expect(toField.decoration?.hintText, 'Dove vuoi andare?');

    expect(find.text('Posizione attuale'), findsNothing);
  });

  testWidgets('mostra le icone principali della card', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildTestWidget());

    expect(find.byIcon(Icons.navigation_rounded), findsNWidgets(2));
    expect(find.byIcon(Icons.place_rounded), findsOneWidget);
    expect(find.byIcon(Icons.swap_vert_rounded), findsOneWidget);
  });

  testWidgets(
    'il bottone Cerca percorso è disabilitato se mancano partenza o destinazione',
    (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget(onSearch: (_, _) {}));

      final button = tester.widget<FilledButton>(
        find.widgetWithText(FilledButton, 'Cerca percorso'),
      );

      expect(button.onPressed, isNull);
    },
  );

  testWidgets(
    'il bottone Cerca percorso resta disabilitato se manca la partenza',
    (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget(onSearch: (_, _) {}));

      final fields = find.byType(TextField);

      await tester.enterText(fields.at(1), 'Università');
      await tester.pump();

      final button = tester.widget<FilledButton>(
        find.widgetWithText(FilledButton, 'Cerca percorso'),
      );

      expect(button.onPressed, isNull);
    },
  );

  testWidgets(
    'il bottone Cerca percorso resta disabilitato se manca la destinazione',
    (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget(onSearch: (_, _) {}));

      final fields = find.byType(TextField);

      await tester.enterText(fields.at(0), 'Terminal Bus');
      await tester.pump();

      final button = tester.widget<FilledButton>(
        find.widgetWithText(FilledButton, 'Cerca percorso'),
      );

      expect(button.onPressed, isNull);
    },
  );

  testWidgets(
    'chiama onSearch con partenza e destinazione quando entrambi i campi sono compilati',
    (WidgetTester tester) async {
      String? searchedFrom;
      String? searchedTo;

      await tester.pumpWidget(
        buildTestWidget(
          onSearch: (from, to) {
            searchedFrom = from;
            searchedTo = to;
          },
        ),
      );

      final fields = find.byType(TextField);

      await tester.enterText(fields.at(0), 'Terminal Bus');
      await tester.enterText(fields.at(1), 'Università');
      await tester.pump();

      await tester.tap(find.widgetWithText(FilledButton, 'Cerca percorso'));
      await tester.pump();

      expect(searchedFrom, 'Terminal Bus');
      expect(searchedTo, 'Università');
    },
  );

  testWidgets('non chiama onSearch se la partenza contiene solo spazi', (
    WidgetTester tester,
  ) async {
    var searchCalled = false;

    await tester.pumpWidget(
      buildTestWidget(
        onSearch: (_, _) {
          searchCalled = true;
        },
      ),
    );

    final fields = find.byType(TextField);

    await tester.enterText(fields.at(0), '   ');
    await tester.enterText(fields.at(1), 'Università');
    await tester.pump();

    final button = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Cerca percorso'),
    );

    expect(button.onPressed, isNull);
    expect(searchCalled, isFalse);
  });

  testWidgets('non chiama onSearch se la destinazione contiene solo spazi', (
    WidgetTester tester,
  ) async {
    var searchCalled = false;

    await tester.pumpWidget(
      buildTestWidget(
        onSearch: (_, _) {
          searchCalled = true;
        },
      ),
    );

    final fields = find.byType(TextField);

    await tester.enterText(fields.at(0), 'Terminal Bus');
    await tester.enterText(fields.at(1), '   ');
    await tester.pump();

    final button = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Cerca percorso'),
    );

    expect(button.onPressed, isNull);
    expect(searchCalled, isFalse);
  });

  testWidgets('il bottone swap inverte partenza e destinazione', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildTestWidget());

    final fields = find.byType(TextField);

    await tester.enterText(fields.at(0), 'Terminal Bus');
    await tester.enterText(fields.at(1), 'Università');
    await tester.pump();

    await tester.tap(find.byIcon(Icons.swap_vert_rounded));
    await tester.pump();

    final firstField = tester.widget<TextField>(fields.at(0));
    final secondField = tester.widget<TextField>(fields.at(1));

    expect(firstField.controller?.text, 'Università');
    expect(secondField.controller?.text, 'Terminal Bus');
  });
}