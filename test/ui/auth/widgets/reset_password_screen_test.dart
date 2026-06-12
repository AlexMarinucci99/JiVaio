import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:jivaio/data/repositories/auth_repository.dart';
import 'package:jivaio/ui/auth/widgets/reset_password_screen.dart';

class FakeAuthRepository implements AuthRepository {
  bool sendPasswordResetEmailCalled = false;
  String? lastEmail;

  @override
  Future<void> sendPasswordResetEmail({required String email}) async {
    sendPasswordResetEmailCalled = true;
    lastEmail = email;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) {
    return super.noSuchMethod(invocation);
  }
}

void main() {
  Widget buildTestWidget({required FakeAuthRepository authRepository}) {
    return MaterialApp(
      home: ResetPasswordScreen(authRepository: authRepository),
    );
  }

  testWidgets('mostra i contenuti principali della schermata', (
    WidgetTester tester,
  ) async {
    final authRepository = FakeAuthRepository();

    await tester.pumpWidget(buildTestWidget(authRepository: authRepository));

    expect(find.text('Password dimenticata?'), findsOneWidget);
    expect(
      find.textContaining('Inserisci l’email associata al tuo account'),
      findsOneWidget,
    );
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('La tua email'), findsOneWidget);
    expect(find.text('Invia link di recupero'), findsOneWidget);
    expect(find.text('Torna ad Accedi'), findsOneWidget);
  });

  testWidgets('il bottone invio è disabilitato con email vuota', (
    WidgetTester tester,
  ) async {
    final authRepository = FakeAuthRepository();

    await tester.pumpWidget(buildTestWidget(authRepository: authRepository));

    final buttonFinder = find.ancestor(
      of: find.text('Invia link di recupero'),
      matching: find.byType(TextButton),
    );

    final button = tester.widget<TextButton>(buttonFinder);

    expect(button.onPressed, isNull);
    expect(authRepository.sendPasswordResetEmailCalled, isFalse);
  });

  testWidgets('inserendo una email il bottone viene abilitato', (
    WidgetTester tester,
  ) async {
    final authRepository = FakeAuthRepository();

    await tester.pumpWidget(buildTestWidget(authRepository: authRepository));

    await tester.enterText(find.byType(TextField), 'utente@jivaio.it');
    await tester.pump();

    final buttonFinder = find.ancestor(
      of: find.text('Invia link di recupero'),
      matching: find.byType(TextButton),
    );

    final button = tester.widget<TextButton>(buttonFinder);

    expect(button.onPressed, isNotNull);
  });

  testWidgets('invia il link di recupero con email valida', (
    WidgetTester tester,
  ) async {
    final authRepository = FakeAuthRepository();

    await tester.pumpWidget(buildTestWidget(authRepository: authRepository));

    await tester.enterText(find.byType(TextField), 'utente@jivaio.it');
    await tester.pump();

    await tester.tap(find.text('Invia link di recupero'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(authRepository.sendPasswordResetEmailCalled, isTrue);
    expect(authRepository.lastEmail, 'utente@jivaio.it');
    expect(
      find.textContaining('Se l’email è associata a un account JiVaio'),
      findsOneWidget,
    );
  });

  testWidgets('mostra errore se email non valida', (WidgetTester tester) async {
    final authRepository = FakeAuthRepository();

    await tester.pumpWidget(buildTestWidget(authRepository: authRepository));

    await tester.enterText(find.byType(TextField), 'email-non-valida');
    await tester.pump();

    await tester.tap(find.text('Invia link di recupero'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(authRepository.sendPasswordResetEmailCalled, isFalse);
    expect(find.text('Inserisci un indirizzo email valido'), findsOneWidget);
  });
}
