import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:jivaio/data/repositories/auth_repository.dart';
import 'package:jivaio/domain/exceptions/auth_failure.dart';
import 'package:jivaio/routing/app_routes.dart';
import 'package:jivaio/ui/auth/view_model/auth_view_model.dart';
import 'package:jivaio/ui/auth/view_model/reset_password_view_model.dart';
import 'package:jivaio/ui/auth/widgets/auth_action_button.dart';
import 'package:jivaio/ui/auth/widgets/auth_choice_screen.dart';
import 'package:jivaio/ui/auth/widgets/reset_password_screen.dart';

import '../../helpers/fake_auth_service.dart';
import '../../helpers/widget_test_helpers.dart';

void main() {
  late FakeAuthService service;
  late int guestCalls;

  setUp(() {
    service = FakeAuthService();
    guestCalls = 0;
  });

  Future<void> mount(WidgetTester tester) async {
    await usePhoneSurface(tester);
    final repository = AuthRepository(service);
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AuthViewModel(repository),
        child: MaterialApp(
          home: AuthChoiceScreen(onContinueAsGuest: () => guestCalls++),
          routes: {
            AppRoutes.resetPassword: (_) => ChangeNotifierProvider(
              create: (_) => ResetPasswordViewModel(repository),
              child: const ResetPasswordScreen(),
            ),
          },
        ),
      ),
    );
  }

  Finder action(String label) => find.widgetWithText(AuthActionButton, label);

  Future<void> fillLogin(
    WidgetTester tester, {
    String email = 'anna@example.com',
  }) async {
    await tester.enterText(textField('Email'), email);
    await tester.enterText(textField('Password'), 'secret123');
  }

  Future<void> fillRegistration(
    WidgetTester tester, {
    String name = 'Anna',
    String email = 'anna@example.com',
    String password = 'secret123',
    String confirm = 'secret123',
  }) async {
    await tapVisible(tester, find.text('Registrati'));
    for (final entry in {
      'Nome': name,
      'Email': email,
      'Password': password,
      'Conferma password': confirm,
    }.entries) {
      await tester.enterText(textField(entry.key), entry.value);
    }
  }

  testWidgets('cambia modalità mantenendo email e password inserite', (
    tester,
  ) async {
    await mount(tester);
    expect(find.text('Bentornato'), findsOneWidget);
    await fillLogin(tester);
    await tapVisible(tester, find.text('Registrati'));
    expect(find.text('Crea account'), findsOneWidget);
    expect(textField('Nome'), findsOneWidget);
    expect(textField('Conferma password'), findsOneWidget);
    expect(
      tester.widget<TextField>(textField('Email')).controller!.text,
      'anna@example.com',
    );
    await tapVisible(tester, find.text('Accedi'));
    expect(textField('Nome'), findsNothing);
    expect(
      tester.widget<TextField>(textField('Password')).controller!.text,
      'secret123',
    );
  });

  testWidgets('mostra e nasconde la password senza cambiarne il testo', (
    tester,
  ) async {
    await mount(tester);
    await fillLogin(tester);
    expect(tester.widget<TextField>(textField('Password')).obscureText, isTrue);
    await tapVisible(tester, find.byTooltip('Mostra password'));
    expect(
      tester.widget<TextField>(textField('Password')).obscureText,
      isFalse,
    );
    await tapVisible(tester, find.byTooltip('Nascondi password'));
    expect(tester.widget<TextField>(textField('Password')).obscureText, isTrue);
    expect(
      tester.widget<TextField>(textField('Password')).controller!.text,
      'secret123',
    );
  });

  for (final invalidEmail in ['', 'indirizzo-non-valido']) {
    testWidgets(
      'login rifiuta ${invalidEmail.isEmpty ? 'campi vuoti' : 'email non valida'}',
      (tester) async {
        await mount(tester);
        if (invalidEmail.isNotEmpty) {
          await fillLogin(tester, email: invalidEmail);
        }
        await tapVisible(tester, action('Accedi'));
        expect(
          find.text(
            invalidEmail.isEmpty
                ? 'Inserisci email e password'
                : 'Inserisci un indirizzo email valido',
          ),
          findsOneWidget,
        );
        expect(service.logins, isEmpty);
      },
    );
  }

  testWidgets('login invia i dati normalizzati e blocca doppi invii e guest', (
    tester,
  ) async {
    service.pending = Completer<void>();
    await mount(tester);
    await fillLogin(tester, email: ' anna@example.com ');
    await tapVisible(tester, action('Accedi'));
    expect(service.logins.single, (
      email: 'anna@example.com',
      password: 'secret123',
    ));
    expect(find.text('Accesso in corso...'), findsOneWidget);
    expect(
      tester.widget<AuthActionButton>(action('Accesso in corso...')).onPressed,
      isNull,
    );
    expect(
      tester.widget<AuthActionButton>(action('Continua come ospite')).onPressed,
      isNull,
    );
    await tapVisible(tester, find.text('Registrati'));
    expect(find.text('Bentornato'), findsOneWidget);
    await tapVisible(tester, action('Accesso in corso...'));
    expect(service.logins, hasLength(1));
    expect(guestCalls, 0);
    service.pending!.complete();
    await tester.pumpAndSettle();
    expect(
      tester.widget<AuthActionButton>(action('Accedi')).onPressed,
      isNotNull,
    );
  });

  testWidgets('mostra l’errore del servizio e permette di riprovare il login', (
    tester,
  ) async {
    service.failure = const AuthFailure(AuthFailureCode.invalidCredential);
    await mount(tester);
    await fillLogin(tester);
    await tapVisible(tester, action('Accedi'));
    expect(find.text('Credenziali non valide.'), findsOneWidget);
    expect(
      tester.widget<AuthActionButton>(action('Accedi')).onPressed,
      isNotNull,
    );
    service.failure = null;
    await tapVisible(tester, action('Accedi'));
    expect(service.logins, hasLength(2));
  });

  final invalidRegistrations = [
    (
      name: '',
      email: 'anna@example.com',
      password: 'secret123',
      confirm: 'secret123',
      message: 'Compila tutti i campi',
    ),
    (
      name: 'Anna',
      email: 'non-valida',
      password: 'secret123',
      confirm: 'secret123',
      message: 'Inserisci un indirizzo email valido',
    ),
    (
      name: 'Anna',
      email: 'anna@example.com',
      password: '123',
      confirm: '123',
      message: 'La password deve contenere almeno 6 caratteri',
    ),
    (
      name: 'Anna',
      email: 'anna@example.com',
      password: 'secret123',
      confirm: 'diversa',
      message: 'Le password non coincidono',
    ),
  ];
  for (final input in invalidRegistrations) {
    testWidgets('registrazione: ${input.message}', (tester) async {
      await mount(tester);
      await fillRegistration(
        tester,
        name: input.name,
        email: input.email,
        password: input.password,
        confirm: input.confirm,
      );
      await tapVisible(tester, action('Registrati'));
      expect(find.text(input.message), findsOneWidget);
      expect(service.registrations, isEmpty);
    });
  }

  testWidgets('registrazione invia nome email e password al servizio', (
    tester,
  ) async {
    await mount(tester);
    await fillRegistration(tester, name: ' Anna ', email: ' anna@example.com ');
    await tapVisible(tester, action('Registrati'));
    expect(service.registrations.single, (
      name: 'Anna',
      email: 'anna@example.com',
      password: 'secret123',
    ));
    expect(service.logins, isEmpty);
  });

  testWidgets('guest invoca la callback senza autenticazione', (tester) async {
    await mount(tester);
    await tapVisible(tester, find.text('Continua come ospite'));
    expect(guestCalls, 1);
    expect(service.logins, isEmpty);
    expect(service.registrations, isEmpty);
    expect(service.googleRequests, 0);
  });

  testWidgets('Google delega al servizio e mostra un annullamento', (
    tester,
  ) async {
    service.failure = const AuthFailure(AuthFailureCode.cancelled);
    await mount(tester);
    await tapVisible(tester, find.text('Google'));
    expect(service.googleRequests, 1);
    expect(find.text('Accesso con Google annullato.'), findsOneWidget);
  });

  testWidgets('apre il recupero password e torna al form di login', (
    tester,
  ) async {
    await mount(tester);
    await fillLogin(tester);
    await tapVisible(tester, find.text('Password dimenticata?'));
    expect(find.byType(ResetPasswordScreen), findsOneWidget);
    await tapVisible(tester, find.text('Torna ad Accedi'));
    expect(find.text('Bentornato'), findsOneWidget);
    expect(
      tester.widget<TextField>(textField('Email')).controller!.text,
      'anna@example.com',
    );
  });
}
