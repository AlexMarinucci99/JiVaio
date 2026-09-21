import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:jivaio/ui/main_navigation/widgets/bottom_nav_bar.dart';

void main() {
  testWidgets('aggiorna la selezione accessibile per Cerca e Impostazioni', (
    tester,
  ) async {
    final selections = <int>[];
    var selectedIndex = 1;
    await tester.pumpWidget(
      MaterialApp(
        home: StatefulBuilder(
          builder: (context, setState) => Scaffold(
            bottomNavigationBar: BottomNavBar(
              selectedIndex: selectedIndex,
              onItemSelected: (index) {
                selections.add(index);
                setState(() => selectedIndex = index);
              },
            ),
          ),
        ),
      ),
    );
    bool selected(String label) => tester
        .widget<Semantics>(
          find.byWidgetPredicate(
            (widget) => widget is Semantics && widget.properties.label == label,
          ),
        )
        .properties
        .selected!;
    expect(selected('Linee'), isTrue);
    await tester.tap(find.text('Impostazioni'));
    await tester.pumpAndSettle();
    expect(selections, [2]);
    expect(selected('Impostazioni'), isTrue);
    expect(selected('Linee'), isFalse);
    await tester.tap(find.text('Cerca'));
    await tester.pumpAndSettle();
    expect(selections, [2, 0]);
    expect(selected('Cerca'), isTrue);
    expect(selected('Impostazioni'), isFalse);
  });

  testWidgets('chiama la callback quando si preme una voce della navbar', (
    WidgetTester tester,
  ) async {
    int? selectedIndex;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          bottomNavigationBar: BottomNavBar(
            selectedIndex: 0,
            onItemSelected: (index) {
              selectedIndex = index;
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('Linee'));
    await tester.pumpAndSettle();

    expect(selectedIndex, 1);
  });
}
