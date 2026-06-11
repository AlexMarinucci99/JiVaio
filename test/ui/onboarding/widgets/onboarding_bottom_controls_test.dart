import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:jivaio/ui/onboarding/widgets/onboarding_bottom_controls.dart';

void main() {
  Widget buildTestWidget({
    required int currentIndex,
    required int itemCount,
    required bool isLastPage,
    required VoidCallback onBack,
    required VoidCallback onNext,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: OnboardingBottomControls(
            currentIndex: currentIndex,
            itemCount: itemCount,
            isLastPage: isLastPage,
            onBack: onBack,
            onNext: onNext,
          ),
        ),
      ),
    );
  }

  testWidgets('mostra il bottone Avanti quando non è l’ultima pagina',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      buildTestWidget(
        currentIndex: 0,
        itemCount: 3,
        isLastPage: false,
        onBack: () {},
        onNext: () {},
      ),
    );

    expect(find.text('Avanti'), findsOneWidget);
    expect(find.text('Inizia'), findsNothing);
  });

  testWidgets('mostra il bottone Inizia quando è l’ultima pagina',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      buildTestWidget(
        currentIndex: 2,
        itemCount: 3,
        isLastPage: true,
        onBack: () {},
        onNext: () {},
      ),
    );

    expect(find.text('Inizia'), findsOneWidget);
    expect(find.text('Avanti'), findsNothing);
  });

  testWidgets('non mostra Indietro nella prima pagina',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      buildTestWidget(
        currentIndex: 0,
        itemCount: 3,
        isLastPage: false,
        onBack: () {},
        onNext: () {},
      ),
    );

    expect(find.text('Indietro'), findsNothing);
    expect(find.byIcon(Icons.chevron_left_rounded), findsNothing);
  });

  testWidgets('mostra Indietro dalla seconda pagina in poi',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      buildTestWidget(
        currentIndex: 1,
        itemCount: 3,
        isLastPage: false,
        onBack: () {},
        onNext: () {},
      ),
    );

    expect(find.text('Indietro'), findsOneWidget);
    expect(find.byIcon(Icons.chevron_left_rounded), findsOneWidget);
  });

  testWidgets('esegue onNext quando viene premuto Avanti',
      (WidgetTester tester) async {
    var nextPressed = false;

    await tester.pumpWidget(
      buildTestWidget(
        currentIndex: 0,
        itemCount: 3,
        isLastPage: false,
        onBack: () {},
        onNext: () {
          nextPressed = true;
        },
      ),
    );

    await tester.tap(find.text('Avanti'));
    await tester.pump();

    expect(nextPressed, isTrue);
  });

  testWidgets('esegue onNext quando viene premuto Inizia',
      (WidgetTester tester) async {
    var nextPressed = false;

    await tester.pumpWidget(
      buildTestWidget(
        currentIndex: 2,
        itemCount: 3,
        isLastPage: true,
        onBack: () {},
        onNext: () {
          nextPressed = true;
        },
      ),
    );

    await tester.tap(find.text('Inizia'));
    await tester.pump();

    expect(nextPressed, isTrue);
  });

  testWidgets('esegue onBack quando viene premuto Indietro',
      (WidgetTester tester) async {
    var backPressed = false;

    await tester.pumpWidget(
      buildTestWidget(
        currentIndex: 1,
        itemCount: 3,
        isLastPage: false,
        onBack: () {
          backPressed = true;
        },
        onNext: () {},
      ),
    );

    await tester.tap(find.text('Indietro'));
    await tester.pump();

    expect(backPressed, isTrue);
  });

  testWidgets('mostra un pallino per ogni slide',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      buildTestWidget(
        currentIndex: 1,
        itemCount: 3,
        isLastPage: false,
        onBack: () {},
        onNext: () {},
      ),
    );

    expect(find.byType(AnimatedContainer), findsNWidgets(3));
  });
}