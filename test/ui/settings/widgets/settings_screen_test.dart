import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:jivaio/ui/settings/widgets/settings_screen.dart';

void main() {
  Widget buildTestWidget({
    required bool isGuest,
    required Future<void> Function() onLogout,
  }) {
    return MaterialApp(
      home: SettingsScreen(isGuest: isGuest, onLogout: onLogout),
    );
  }

  testWidgets('mostra il titolo della schermata impostazioni', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      buildTestWidget(isGuest: false, onLogout: () async {}),
    );

    expect(find.text('Impostazioni'), findsOneWidget);
  });

  testWidgets('mostra Logout quando utente non è guest', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      buildTestWidget(isGuest: false, onLogout: () async {}),
    );

    expect(find.text('Logout'), findsOneWidget);
    expect(find.byIcon(Icons.logout_rounded), findsOneWidget);

    expect(find.text('Accedi o registrati'), findsNothing);
    expect(find.byIcon(Icons.login_rounded), findsNothing);
  });

  testWidgets('mostra Accedi o registrati quando utente è guest', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      buildTestWidget(isGuest: true, onLogout: () async {}),
    );

    expect(find.text('Accedi o registrati'), findsOneWidget);
    expect(find.byIcon(Icons.login_rounded), findsOneWidget);

    expect(find.text('Logout'), findsNothing);
    expect(find.byIcon(Icons.logout_rounded), findsNothing);
  });

  testWidgets('esegue onLogout quando si preme Logout', (
    WidgetTester tester,
  ) async {
    var logoutCalled = false;

    await tester.pumpWidget(
      buildTestWidget(
        isGuest: false,
        onLogout: () async {
          logoutCalled = true;
        },
      ),
    );

    await tester.tap(find.text('Logout'));
    await tester.pump();

    expect(logoutCalled, isTrue);
  });

  testWidgets('esegue onLogout quando il guest preme Accedi o registrati', (
    WidgetTester tester,
  ) async {
    var logoutCalled = false;

    await tester.pumpWidget(
      buildTestWidget(
        isGuest: true,
        onLogout: () async {
          logoutCalled = true;
        },
      ),
    );

    await tester.tap(find.text('Accedi o registrati'));
    await tester.pump();

    expect(logoutCalled, isTrue);
  });

  testWidgets('usa TextButton.icon come azione principale', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      buildTestWidget(isGuest: false, onLogout: () async {}),
    );

    expect(find.byType(TextButton), findsOneWidget);
    expect(find.byType(Icon), findsOneWidget);
  });
}
