import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:jivaio/ui/auth/widgets/auth_register_form.dart';
import 'package:jivaio/ui/auth/widgets/auth_text_field.dart';

void main() {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;

  setUp(() {
    nameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  });

  tearDown(() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  });

  Widget buildTestWidget({
    bool obscurePassword = true,
    bool obscureConfirmPassword = true,
    VoidCallback? onTogglePasswordVisibility,
    VoidCallback? onToggleConfirmPasswordVisibility,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: AuthRegisterForm(
            nameController: nameController,
            emailController: emailController,
            passwordController: passwordController,
            confirmPasswordController: confirmPasswordController,
            obscurePassword: obscurePassword,
            obscureConfirmPassword: obscureConfirmPassword,
            onTogglePasswordVisibility: onTogglePasswordVisibility ?? () {},
            onToggleConfirmPasswordVisibility:
                onToggleConfirmPasswordVisibility ?? () {},
          ),
        ),
      ),
    );
  }

  testWidgets('mostra i campi Nome, Email, Password e Conferma password',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      buildTestWidget(),
    );

    expect(find.byType(AuthTextField), findsNWidgets(4));

    expect(find.text('Nome'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Conferma password'), findsOneWidget);

    expect(find.byIcon(Icons.person_outline), findsOneWidget);
    expect(find.byIcon(Icons.email_outlined), findsOneWidget);
    expect(find.byIcon(Icons.lock_outline), findsNWidgets(2));
  });

  testWidgets('aggiorna tutti i controller quando vengono inseriti i dati',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      buildTestWidget(),
    );

    final fields = find.byType(TextField);

    await tester.enterText(fields.at(0), 'Mario Rossi');
    await tester.enterText(fields.at(1), 'mario@test.it');
    await tester.enterText(fields.at(2), 'password123');
    await tester.enterText(fields.at(3), 'password123');
    await tester.pump();

    expect(nameController.text, 'Mario Rossi');
    expect(emailController.text, 'mario@test.it');
    expect(passwordController.text, 'password123');
    expect(confirmPasswordController.text, 'password123');
  });

  testWidgets('usa TextInputType.emailAddress per il campo email',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      buildTestWidget(),
    );

    final emailField = tester.widget<TextField>(
      find.byType(TextField).at(1),
    );

    expect(emailField.keyboardType, TextInputType.emailAddress);
  });

  testWidgets('nasconde password e conferma password quando gli obscure sono true',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      buildTestWidget(
        obscurePassword: true,
        obscureConfirmPassword: true,
      ),
    );

    final passwordField = tester.widget<TextField>(
      find.byType(TextField).at(2),
    );

    final confirmPasswordField = tester.widget<TextField>(
      find.byType(TextField).at(3),
    );

    expect(passwordField.obscureText, isTrue);
    expect(confirmPasswordField.obscureText, isTrue);

    expect(find.byIcon(Icons.visibility_outlined), findsNWidgets(2));
  });

  testWidgets('mostra password e conferma password quando gli obscure sono false',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      buildTestWidget(
        obscurePassword: false,
        obscureConfirmPassword: false,
      ),
    );

    final passwordField = tester.widget<TextField>(
      find.byType(TextField).at(2),
    );

    final confirmPasswordField = tester.widget<TextField>(
      find.byType(TextField).at(3),
    );

    expect(passwordField.obscureText, isFalse);
    expect(confirmPasswordField.obscureText, isFalse);

    expect(find.byIcon(Icons.visibility_off_outlined), findsNWidgets(2));
  });

  testWidgets('esegue onTogglePasswordVisibility quando si preme la prima icona',
      (WidgetTester tester) async {
    var passwordToggled = false;

    await tester.pumpWidget(
      buildTestWidget(
        onTogglePasswordVisibility: () {
          passwordToggled = true;
        },
      ),
    );

    await tester.tap(find.byIcon(Icons.visibility_outlined).at(0));
    await tester.pump();

    expect(passwordToggled, isTrue);
  });

  testWidgets(
      'esegue onToggleConfirmPasswordVisibility quando si preme la seconda icona',
      (WidgetTester tester) async {
    var confirmPasswordToggled = false;

    await tester.pumpWidget(
      buildTestWidget(
        onToggleConfirmPasswordVisibility: () {
          confirmPasswordToggled = true;
        },
      ),
    );

    await tester.tap(find.byIcon(Icons.visibility_outlined).at(1));
    await tester.pump();

    expect(confirmPasswordToggled, isTrue);
  });

  testWidgets('i due toggle password sono indipendenti',
      (WidgetTester tester) async {
    var passwordToggleCount = 0;
    var confirmPasswordToggleCount = 0;

    await tester.pumpWidget(
      buildTestWidget(
        onTogglePasswordVisibility: () {
          passwordToggleCount++;
        },
        onToggleConfirmPasswordVisibility: () {
          confirmPasswordToggleCount++;
        },
      ),
    );

    await tester.tap(find.byIcon(Icons.visibility_outlined).at(0));
    await tester.pump();

    await tester.tap(find.byIcon(Icons.visibility_outlined).at(1));
    await tester.pump();

    expect(passwordToggleCount, 1);
    expect(confirmPasswordToggleCount, 1);
  });
}