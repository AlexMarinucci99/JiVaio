import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:jivaio/ui/core/widgets/app_segmented_control.dart';

void main() {
  Widget buildTestWidget({
    required String selectedValue,
    required ValueChanged<String> onChanged,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: AppSegmentedControl<String>(
            selectedValue: selectedValue,
            onChanged: onChanged,
            items: const [
              AppSegmentedControlItem<String>(value: 'all', label: 'Tutte'),
              AppSegmentedControlItem<String>(
                value: 'saved',
                label: 'Salvate',
                badgeLabel: '2',
              ),
              AppSegmentedControlItem<String>(
                value: 'nearby',
                label: 'Vicine',
                badgeLabel: '5',
              ),
            ],
          ),
        ),
      ),
    );
  }

  testWidgets('mostra tutte le opzioni del segmented control', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      buildTestWidget(selectedValue: 'all', onChanged: (_) {}),
    );

    expect(find.text('Tutte'), findsOneWidget);
    expect(find.text('Salvate'), findsOneWidget);
    expect(find.text('Vicine'), findsOneWidget);
    expect(find.byType(TextButton), findsNWidgets(3));
  });

  testWidgets('mostra i badge delle opzioni che hanno badgeLabel', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      buildTestWidget(selectedValue: 'all', onChanged: (_) {}),
    );

    expect(find.text('2'), findsOneWidget);
    expect(find.text('5'), findsOneWidget);
  });

  testWidgets(
    'chiama onChanged quando viene premuta una voce non selezionata',
    (WidgetTester tester) async {
      String? selectedValue;

      await tester.pumpWidget(
        buildTestWidget(
          selectedValue: 'all',
          onChanged: (value) {
            selectedValue = value;
          },
        ),
      );

      await tester.tap(find.text('Salvate'));
      await tester.pump();

      expect(selectedValue, 'saved');
    },
  );

  testWidgets(
    'non chiama onChanged quando viene premuta la voce già selezionata',
    (WidgetTester tester) async {
      String? selectedValue;

      await tester.pumpWidget(
        buildTestWidget(
          selectedValue: 'all',
          onChanged: (value) {
            selectedValue = value;
          },
        ),
      );

      await tester.tap(find.text('Tutte'));
      await tester.pump();

      expect(selectedValue, isNull);
    },
  );

  testWidgets('chiama onChanged con il valore corretto della terza voce', (
    WidgetTester tester,
  ) async {
    String? selectedValue;

    await tester.pumpWidget(
      buildTestWidget(
        selectedValue: 'all',
        onChanged: (value) {
          selectedValue = value;
        },
      ),
    );

    await tester.tap(find.text('Vicine'));
    await tester.pump();

    expect(selectedValue, 'nearby');
  });

  testWidgets('non accetta meno di due item', (WidgetTester tester) async {
    expect(
      () => AppSegmentedControl<String>(
        selectedValue: 'all',
        onChanged: (_) {},
        items: const [
          AppSegmentedControlItem<String>(value: 'all', label: 'Tutte'),
        ],
      ),
      throwsAssertionError,
    );
  });

  testWidgets('non accetta più di quattro item', (WidgetTester tester) async {
    expect(
      () => AppSegmentedControl<String>(
        selectedValue: '1',
        onChanged: (_) {},
        items: const [
          AppSegmentedControlItem<String>(value: '1', label: 'Uno'),
          AppSegmentedControlItem<String>(value: '2', label: 'Due'),
          AppSegmentedControlItem<String>(value: '3', label: 'Tre'),
          AppSegmentedControlItem<String>(value: '4', label: 'Quattro'),
          AppSegmentedControlItem<String>(value: '5', label: 'Cinque'),
        ],
      ),
      throwsAssertionError,
    );
  });
}
