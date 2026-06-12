import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:jivaio/ui/auth/widgets/auth_text_field.dart';

void main() {
  Widget buildTestWidget({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: AuthTextField(
            controller: controller,
            label: label,
            icon: icon,
            keyboardType: keyboardType,
            obscureText: obscureText,
            suffixIcon: suffixIcon,
          ),
        ),
      ),
    );
  }

  testWidgets('mostra label e icona del campo input', (
    WidgetTester tester,
  ) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      buildTestWidget(
        controller: controller,
        label: 'Email',
        icon: Icons.email_outlined,
      ),
    );

    expect(find.text('Email'), findsOneWidget);
    expect(find.byIcon(Icons.email_outlined), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
  });

  testWidgets('aggiorna il controller quando viene inserito testo', (
    WidgetTester tester,
  ) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      buildTestWidget(
        controller: controller,
        label: 'Email',
        icon: Icons.email_outlined,
        keyboardType: TextInputType.emailAddress,
      ),
    );

    await tester.enterText(find.byType(TextField), 'test@email.com');
    await tester.pump();

    expect(controller.text, 'test@email.com');
  });

  testWidgets('usa obscureText quando il campo è una password', (
    WidgetTester tester,
  ) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      buildTestWidget(
        controller: controller,
        label: 'Password',
        icon: Icons.lock_outline,
        obscureText: true,
      ),
    );

    final textField = tester.widget<TextField>(find.byType(TextField));

    expect(textField.obscureText, isTrue);
    expect(find.text('Password'), findsOneWidget);
    expect(find.byIcon(Icons.lock_outline), findsOneWidget);
  });

  testWidgets('mostra la suffix icon quando viene fornita', (
    WidgetTester tester,
  ) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      buildTestWidget(
        controller: controller,
        label: 'Password',
        icon: Icons.lock_outline,
        suffixIcon: const Icon(Icons.visibility_off_outlined),
      ),
    );

    expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);
  });
}
