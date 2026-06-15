import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:jivaio/domain/models/app_user.dart';
import 'package:jivaio/ui/settings/widgets/settings_screen.dart';

void main() {
  Widget buildTestWidget({
  required bool isGuest,
  required Future<void> Function() onLogout,
}) {
  final user = isGuest
      ? null
      : const AppUser(
          id: 'test-user-id',
          email: 'utente@test.it',
          displayName: 'Utente Test',
        );

  return MaterialApp(
    home: SettingsScreen(
      user: user,
      onLogout: onLogout,
    ),
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

  testWidgets('mostra nome ed email dell’utente autenticato', (
  WidgetTester tester,
) async {
  await tester.pumpWidget(
    buildTestWidget(
      isGuest: false,
      onLogout: () async {},
    ),
  );

  expect(find.text('Utente Test'), findsOneWidget);
  expect(find.text('utente@test.it'), findsOneWidget);
});

testWidgets('mostra le informazioni della modalità guest', (
  WidgetTester tester,
) async {
  await tester.pumpWidget(
    buildTestWidget(
      isGuest: true,
      onLogout: () async {},
    ),
  );

  expect(find.text('Modalità ospite'), findsOneWidget);
  expect(
    find.text('Accedi per personalizzare la tua esperienza.'),
    findsOneWidget,
  );
});

  testWidgets("mostra Esci dall'account per l'utente autenticato", (
  WidgetTester tester,
) async {
  await tester.pumpWidget(
    buildTestWidget(
      isGuest: false,
      onLogout: () async {},
    ),
  );

  expect(find.text("Esci dall'account"), findsOneWidget);
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

    expect(find.text("Esci dall'account"), findsNothing);
    expect(find.byIcon(Icons.logout_rounded), findsNothing);
  });

  testWidgets("esegue onLogout quando si preme Esci dall'account", (
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

    await tester.tap(find.text("Esci dall'account"));
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
}
