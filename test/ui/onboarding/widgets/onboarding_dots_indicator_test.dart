import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:jivaio/ui/onboarding/widgets/onboarding_dots_indicator.dart';

void main() {
  Widget buildTestWidget({
    required int currentIndex,
    required int itemCount,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: OnboardingDotsIndicator(
            currentIndex: currentIndex,
            itemCount: itemCount,
          ),
        ),
      ),
    );
  }

  testWidgets('mostra un pallino per ogni slide', (WidgetTester tester) async {
    await tester.pumpWidget(
      buildTestWidget(
        currentIndex: 0,
        itemCount: 3,
      ),
    );

    expect(find.byType(AnimatedContainer), findsNWidgets(3));
  });

  testWidgets('rende più largo il primo pallino quando currentIndex è 0',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      buildTestWidget(
        currentIndex: 0,
        itemCount: 3,
      ),
    );

    final dots = tester
        .widgetList<AnimatedContainer>(find.byType(AnimatedContainer))
        .toList();

    expect(dots[0].constraints?.maxWidth, 26);
    expect(dots[1].constraints?.maxWidth, 9);
    expect(dots[2].constraints?.maxWidth, 9);
  });

  testWidgets('rende più largo il terzo pallino quando currentIndex è 2',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      buildTestWidget(
        currentIndex: 2,
        itemCount: 3,
      ),
    );

    final dots = tester
        .widgetList<AnimatedContainer>(find.byType(AnimatedContainer))
        .toList();

    expect(dots[0].constraints?.maxWidth, 9);
    expect(dots[1].constraints?.maxWidth, 9);
    expect(dots[2].constraints?.maxWidth, 26);
  });

  testWidgets('non mostra pallini quando itemCount è zero',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      buildTestWidget(
        currentIndex: 0,
        itemCount: 0,
      ),
    );

    expect(find.byType(AnimatedContainer), findsNothing);
  });
}