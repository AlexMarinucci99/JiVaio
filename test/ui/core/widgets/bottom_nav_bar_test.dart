import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:jivaio/ui/core/widgets/bottom_nav_bar.dart';

void main() {
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
