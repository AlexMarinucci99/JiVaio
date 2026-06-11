import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:jivaio/data/repositories/auth_repository.dart';
import 'package:jivaio/ui/auth/widgets/auth_choice_screen.dart';

class FakeAuthRepository implements AuthRepository {
  bool loginCalled = false;
  bool registerCalled = false;

  String? lastEmail;
  String? lastPassword;
  String? lastName;

  @override
  Future<void> login({
    required String email,
    required String password,
  }) async {
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
              body: Center(
                child: Text('Reset Password Test'),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> tapVisibleText(
    WidgetTester tester,
    String text, {
    bool last = false,
  }) async {
    final finder = last ? find.text(text).last : find.text(text).first;

    await tester.ensureVisible(finder);
    await tester.pump();

    await tester.tap(finder);
    await tester.pump();
  }

  testWidgets('mostra la schermata iniziale in modalità login',
      (WidgetTester tester) async {
    final authRepository = FakeAuthRepository();

    await tester.pumpWidget(
      buildTestWidget(
        authRepository: authRepository,
      ),
    );

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

  testWidgets('passa dalla modalità login alla modalità registrazione',
      (WidgetTester tester) async {
    final authRepository = FakeAuthRepository();

    await tester.pumpWidget(
      buildTestWidget(
        authRepository: authRepository,
      ),
    );

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

  testWidgets('continua come ospite quando viene premuto il bottone guest',
      (WidgetTester tester) async {
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

    await tapVisibleText(tester, 'Continua come ospite');

    expect(guestCalled, isTrue);
  });

  testWidgets('mostra snackbar quando si preme login con Google',
      (WidgetTester tester) async {
    final authRepository = FakeAuthRepository();

    await tester.pumpWidget(
      buildTestWidget(
        authRepository: authRepository,
      ),
    );

    await tapVisibleText(tester, 'Google');
    await tester.pump();

    expect(
      find.text('Accesso con Google non ancora implementato'),
      findsOneWidget,
    );
  });

  testWidgets('apre la schermata reset password',
      (WidgetTester tester) async {
    final authRepository = FakeAuthRepository();

    await tester.pumpWidget(
      buildTestWidget(
        authRepository: authRepository,
      ),
    );

    await tapVisibleText(tester, 'Password dimenticata?');
    await tester.pumpAndSettle();

    expect(find.text('Reset Password Test'), findsOneWidget);
  });

  testWidgets('invia login con email e password valide',
      (WidgetTester tester) async {
    final authRepository = FakeAuthRepository();

    await tester.pumpWidget(
      buildTestWidget(
        authRepository: authRepository,
      ),
    );

    await tester.enterText(
      find.byType(TextField).at(0),
      'utente@jivaio.it',
    );
    await tester.enterText(
      find.byType(TextField).at(1),
      'password123',
    );

    await tapVisibleText(
      tester,
      'Accedi',
      last: true,
    );

    await tester.pump();

    expect(authRepository.loginCalled, isTrue);
    expect(authRepository.lastEmail, 'utente@jivaio.it');
    expect(authRepository.lastPassword, 'password123');
  });

  testWidgets('invia registrazione con dati validi',
      (WidgetTester tester) async {
    final authRepository = FakeAuthRepository();

    await tester.pumpWidget(
      buildTestWidget(
        authRepository: authRepository,
      ),
    );

    await tapVisibleText(tester, 'Registrati');

    await tester.enterText(
      find.byType(TextField).at(0),
      'Mario Rossi',
    );
    await tester.enterText(
      find.byType(TextField).at(1),
      'mario@jivaio.it',
    );
    await tester.enterText(
      find.byType(TextField).at(2),
      'password123',
    );
    await tester.enterText(
      find.byType(TextField).at(3),
      'password123',
    );

    await tapVisibleText(
      tester,
      'Registrati',
      last: true,
    );

    await tester.pump();

    expect(authRepository.registerCalled, isTrue);
    expect(authRepository.lastName, 'Mario Rossi');
    expect(authRepository.lastEmail, 'mario@jivaio.it');
    expect(authRepository.lastPassword, 'password123');
  });
}