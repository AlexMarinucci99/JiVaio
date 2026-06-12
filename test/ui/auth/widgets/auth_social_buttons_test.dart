import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:jivaio/ui/auth/widgets/auth_social_buttons.dart';

void main() {
  Widget buildTestWidget({
    required VoidCallback onGooglePressed,
    required VoidCallback onApplePressed,
    required VoidCallback onFacebookPressed,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: AuthSocialButtons(
            onGooglePressed: onGooglePressed,
            onApplePressed: onApplePressed,
            onFacebookPressed: onFacebookPressed,
          ),
        ),
      ),
    );
  }

  testWidgets('mostra i tre bottoni social', (WidgetTester tester) async {
    await tester.pumpWidget(
      buildTestWidget(
        onGooglePressed: () {},
        onApplePressed: () {},
        onFacebookPressed: () {},
      ),
    );

    expect(find.text('Google'), findsOneWidget);
    expect(find.text('Apple'), findsOneWidget);
    expect(find.text('Facebook'), findsOneWidget);
    expect(find.byType(OutlinedButton), findsNWidgets(3));
  });

  testWidgets('esegue la callback Google quando viene premuto Google', (
    WidgetTester tester,
  ) async {
    var googlePressed = false;

    await tester.pumpWidget(
      buildTestWidget(
        onGooglePressed: () {
          googlePressed = true;
        },
        onApplePressed: () {},
        onFacebookPressed: () {},
      ),
    );

    await tester.tap(find.text('Google'));
    await tester.pumpAndSettle();

    expect(googlePressed, isTrue);
  });

  testWidgets('esegue la callback Apple quando viene premuto Apple', (
    WidgetTester tester,
  ) async {
    var applePressed = false;

    await tester.pumpWidget(
      buildTestWidget(
        onGooglePressed: () {},
        onApplePressed: () {
          applePressed = true;
        },
        onFacebookPressed: () {},
      ),
    );

    await tester.tap(find.text('Apple'));
    await tester.pumpAndSettle();

    expect(applePressed, isTrue);
  });

  testWidgets('esegue la callback Facebook quando viene premuto Facebook', (
    WidgetTester tester,
  ) async {
    var facebookPressed = false;

    await tester.pumpWidget(
      buildTestWidget(
        onGooglePressed: () {},
        onApplePressed: () {},
        onFacebookPressed: () {
          facebookPressed = true;
        },
      ),
    );

    await tester.tap(find.text('Facebook'));
    await tester.pumpAndSettle();

    expect(facebookPressed, isTrue);
  });
}
