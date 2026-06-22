import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:jivaio/data/repositories/auth_repository.dart';
import 'package:jivaio/ui/auth/widgets/auth_action_button.dart';
import 'package:jivaio/ui/auth/widgets/auth_choice_screen.dart';
import 'package:jivaio/ui/auth/widgets/auth_login_form.dart';
import 'package:jivaio/ui/auth/widgets/auth_register_form.dart';

class FakeAuthRepository implements AuthRepository {
  bool loginCalled = false;
  bool registerCalled = false;

  String? lastEmail;
  String? lastPassword;
  String? lastName;

  @override
  Future<void> login({required String email, required String password}) async {
    loginCalled = true;
    lastEmail = email;
    lastPassword = password;
  }

  @override
  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    registerCalled = true;
    lastName = name;
    lastEmail = email;
    lastPassword = password;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) {
    return super.noSuchMethod(invocation);
  }
}

void main() {
  Widget buildTestWidget({
    required FakeAuthRepository authRepository,
    VoidCallback? onContinueAsGuest,
  }) {
    return MaterialApp(
      home: AuthChoiceScreen(
        authRepository: authRepository,
        onContinueAsGuest: onContinueAsGuest ?? () {},
      ),
      onGenerateRoute: (settings) {
        return MaterialPageRoute<void>(
          builder: (_) {
            return const Scaffold(
              body: Center(child: Text('Reset Password Test')),
            );
          },
        );
      },
    );
  }

  Future<void> tapVisibleFinder(
    WidgetTester tester,
    Finder finder, {
    bool settle = false,
  }) async {
    expect(finder, findsOneWidget);

    await tester.ensureVisible(finder);
    await tester.pump();

    await tester.tap(finder);

    if (settle) {
      await tester.pumpAndSettle();
    } else {
      await tester.pump();
    }
  }

  Future<void> tapVisibleText(WidgetTester tester, String text) async {
    await tapVisibleFinder(tester, find.text(text));
  }

  Future<void> tapAuthActionButton(
    WidgetTester tester,
    String label, {
    bool settle = false,
  }) async {
    await tapVisibleFinder(
      tester,
      find.widgetWithText(AuthActionButton, label),
      settle: settle,
    );
  }

  Finder findLoginTextFields() {
    final fields = find.descendant(
      of: find.byType(AuthLoginForm),
      matching: find.byType(TextField),
    );

    expect(fields, findsNWidgets(2));
    return fields;
  }

  Finder findRegisterTextFields() {
    final fields = find.descendant(
      of: find.byType(AuthRegisterForm),
      matching: find.byType(TextField),
    );

    expect(fields, findsNWidgets(4));
    return fields;
  }

  testWidgets('mostra la schermata iniziale in modalità login', (
    WidgetTester tester,
  ) async {
    final authRepository = FakeAuthRepository();

    await tester.pumpWidget(buildTestWidget(authRepository: authRepository));

    expect(find.text('Come vuoi continuare?'), findsOneWidget);
    expect(find.text('Bentornato'), findsOneWidget);
    expect(
      find.text('Accedi per salvare linee e ricevere notifiche.'),
      findsOneWidget,
    );
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Password dimenticata?'), findsOneWidget);
    expect(find.text('Continua come ospite'), findsOneWidget);
  });

  testWidgets('passa dalla modalità login alla modalità registrazione', (
    WidgetTester tester,
  ) async {
    final authRepository = FakeAuthRepository();

    await tester.pumpWidget(buildTestWidget(authRepository: authRepository));

    await tapVisibleText(tester, 'Registrati');

    expect(find.text('Crea account'), findsOneWidget);
    expect(
      find.text('Registrati per personalizzare la tua esperienza.'),
      findsOneWidget,
    );
    expect(find.text('Nome'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Conferma password'), findsOneWidget);
  });

  testWidgets('continua come ospite quando viene premuto il bottone guest', (
    WidgetTester tester,
  ) async {
    final authRepository = FakeAuthRepository();
    var guestCalled = false;

    await tester.pumpWidget(
      buildTestWidget(
        authRepository: authRepository,
        onContinueAsGuest: () {
          guestCalled = true;
        },
      ),
    );

    await tapAuthActionButton(tester, 'Continua come ospite');

    expect(guestCalled, isTrue);
  });

  testWidgets('mostra snackbar quando si preme login con Google', (
    WidgetTester tester,
  ) async {
    final authRepository = FakeAuthRepository();

    await tester.pumpWidget(buildTestWidget(authRepository: authRepository));

    await tapVisibleText(tester, 'Google');
    await tester.pump();

    expect(
      find.text('Accesso con Google non ancora implementato'),
      findsOneWidget,
    );
  });

  testWidgets('apre la schermata reset password', (WidgetTester tester) async {
    final authRepository = FakeAuthRepository();

    await tester.pumpWidget(buildTestWidget(authRepository: authRepository));

    await tapVisibleText(tester, 'Password dimenticata?');
    await tester.pumpAndSettle();

    expect(find.text('Reset Password Test'), findsOneWidget);
  });

  testWidgets('invia login con email e password valide', (
    WidgetTester tester,
  ) async {
    final authRepository = FakeAuthRepository();

    await tester.pumpWidget(buildTestWidget(authRepository: authRepository));

    final fields = findLoginTextFields();

    await tester.enterText(fields.at(0), 'utente@jivaio.it');
    await tester.enterText(fields.at(1), 'password123');
    await tester.pump();

    await tapAuthActionButton(tester, 'Accedi');

    expect(authRepository.loginCalled, isTrue);
    expect(authRepository.lastEmail, 'utente@jivaio.it');
    expect(authRepository.lastPassword, 'password123');
  });

  testWidgets('invia registrazione con dati validi', (
    WidgetTester tester,
  ) async {
    final authRepository = FakeAuthRepository();

    await tester.pumpWidget(buildTestWidget(authRepository: authRepository));

    await tapVisibleText(tester, 'Registrati');

    final fields = findRegisterTextFields();

    await tester.enterText(fields.at(0), 'Mario Rossi');
    await tester.enterText(fields.at(1), 'mario@jivaio.it');
    await tester.enterText(fields.at(2), 'password123');
    await tester.enterText(fields.at(3), 'password123');
    await tester.pump();

    await tapAuthActionButton(tester, 'Registrati');

    expect(authRepository.registerCalled, isTrue);
    expect(authRepository.lastName, 'Mario Rossi');
    expect(authRepository.lastEmail, 'mario@jivaio.it');
    expect(authRepository.lastPassword, 'password123');
  });
}