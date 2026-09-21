import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:jivaio/data/repositories/auth_repository.dart';
import 'package:jivaio/domain/exceptions/auth_failure.dart';
import 'package:jivaio/ui/auth/view_model/reset_password_view_model.dart';
import 'package:jivaio/ui/auth/widgets/auth_action_button.dart';
import 'package:jivaio/ui/auth/widgets/reset_password_screen.dart';

import '../../helpers/fake_auth_service.dart';
import '../../helpers/widget_test_helpers.dart';

void main() {
  late FakeAuthService service;
  setUp(() => service = FakeAuthService());

  Future<void> mount(WidgetTester tester) async {
    await usePhoneSurface(tester);
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => ResetPasswordViewModel(AuthRepository(service)),
        child: const MaterialApp(home: ResetPasswordScreen()),
      ),
    );
  }

  testWidgets('disabilita input vuoti e valida l’email prima dell’invio', (
    tester,
  ) async {
    await mount(tester);
    expect(
      tester.widget<AuthActionButton>(find.byType(AuthActionButton)).onPressed,
      isNull,
    );
    await tester.enterText(textField('La tua email'), '   ');
    await tester.pump();
    expect(
      tester.widget<AuthActionButton>(find.byType(AuthActionButton)).onPressed,
      isNull,
    );
    await tester.enterText(textField('La tua email'), 'non-valida');
    await tester.pump();
    await tapVisible(tester, find.text('Invia link di recupero'));
    expect(find.text('Inserisci un indirizzo email valido'), findsOneWidget);
    expect(service.resetEmails, isEmpty);
  });

  testWidgets('invia email normalizzata e mostra caricamento e conferma', (
    tester,
  ) async {
    service.pending = Completer<void>();
    await mount(tester);
    await tester.enterText(textField('La tua email'), ' anna@example.com ');
    await tester.pump();
    await tapVisible(tester, find.text('Invia link di recupero'));
    expect(service.resetEmails, ['anna@example.com']);
    expect(find.text('Invio in corso...'), findsOneWidget);
    expect(
      tester.widget<AuthActionButton>(find.byType(AuthActionButton)).onPressed,
      isNull,
    );
    service.pending!.complete();
    await tester.pumpAndSettle();
    expect(
      find.text(
        'Se l’email è associata a un account JiVaio, riceverai un link per reimpostare la password.',
      ),
      findsOneWidget,
    );
    expect(
      tester.widget<AuthActionButton>(find.byType(AuthActionButton)).onPressed,
      isNotNull,
    );
  });

  testWidgets('mostra un errore di rete e riabilita il pulsante', (
    tester,
  ) async {
    service.failure = const AuthFailure(AuthFailureCode.networkRequestFailed);
    await mount(tester);
    await tester.enterText(textField('La tua email'), 'anna@example.com');
    await tester.pump();
    await tapVisible(tester, find.text('Invia link di recupero'));
    expect(find.text('Controlla la connessione e riprova.'), findsOneWidget);
    expect(
      tester.widget<AuthActionButton>(find.byType(AuthActionButton)).onPressed,
      isNotNull,
    );
  });
}
