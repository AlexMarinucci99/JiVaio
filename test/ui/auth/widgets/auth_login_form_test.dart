import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:jivaio/ui/auth/widgets/auth_login_form.dart';
import 'package:jivaio/ui/auth/widgets/auth_text_field.dart';

void main() {
  late TextEditingController emailController;
  late TextEditingController passwordController;

  setUp(() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
  });

  tearDown(() {
    emailController.dispose();
    passwordController.dispose();
  });

  Widget buildTestWidget({
    bool obscurePassword = true,
    VoidCallback? onTogglePasswordVisibility,
    VoidCallback? onForgotPassword,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: AuthLoginForm(
            emailController: emailController,
            passwordController: passwordController,
            obscurePassword: obscurePassword,
            onTogglePasswordVisibility: onTogglePasswordVisibility ?? () {},
            onForgotPassword: onForgotPassword ?? () {},
          ),
        ),
      ),
    );
  }

  testWidgets('mostra i campi Email e Password', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());

    expect(find.byType(AuthTextField), findsNWidgets(2));
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.byIcon(Icons.email_outlined), findsOneWidget);
    expect(find.byIcon(Icons.lock_outline), findsOneWidget);
  });

  testWidgets(
    'aggiorna i controller quando vengono inseriti email e password',
    (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());

      final fields = find.byType(TextField);

      await tester.enterText(fields.at(0), 'utente@test.it');
      await tester.enterText(fields.at(1), 'password123');
      await tester.pump();

      expect(emailController.text, 'utente@test.it');
      expect(passwordController.text, 'password123');
    },
  );

  testWidgets('usa TextInputType.emailAddress per il campo email', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildTestWidget());

    final emailField = tester.widget<TextField>(find.byType(TextField).at(0));

    expect(emailField.keyboardType, TextInputType.emailAddress);
  });

  testWidgets('nasconde la password quando obscurePassword è true', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildTestWidget(obscurePassword: true));

    final passwordField = tester.widget<TextField>(
      find.byType(TextField).at(1),
    );

    expect(passwordField.obscureText, isTrue);
    expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
  });

  testWidgets('mostra la password quando obscurePassword è false', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildTestWidget(obscurePassword: false));

    final passwordField = tester.widget<TextField>(
      find.byType(TextField).at(1),
    );

    expect(passwordField.obscureText, isFalse);
    expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);
  });

  testWidgets(
    'esegue onTogglePasswordVisibility quando si preme icona visibilità',
    (WidgetTester tester) async {
      var toggled = false;

      await tester.pumpWidget(
        buildTestWidget(
          onTogglePasswordVisibility: () {
            toggled = true;
          },
        ),
      );

      await tester.tap(find.byIcon(Icons.visibility_outlined));
      await tester.pump();

      expect(toggled, isTrue);
    },
  );

  testWidgets('mostra link Password dimenticata', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());

    expect(find.text('Password dimenticata?'), findsOneWidget);
  });

  testWidgets('esegue onForgotPassword quando si preme Password dimenticata', (
    WidgetTester tester,
  ) async {
    var forgotPressed = false;

    await tester.pumpWidget(
      buildTestWidget(
        onForgotPassword: () {
          forgotPressed = true;
        },
      ),
    );

    await tester.tap(find.text('Password dimenticata?'));
    await tester.pump();

    expect(forgotPressed, isTrue);
  });
}
