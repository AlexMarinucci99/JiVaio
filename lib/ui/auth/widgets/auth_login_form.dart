import 'package:flutter/material.dart';

import 'auth_text_field.dart';

/// Form di accesso della feature auth.
class AuthLoginForm extends StatelessWidget {
  const AuthLoginForm({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.obscurePassword,
    required this.onTogglePasswordVisibility,
    required this.onForgotPassword,
    this.textFieldColors = const AuthTextFieldColors(),
    this.linkColor = const Color(0xFF191970),
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final VoidCallback onTogglePasswordVisibility;
  final VoidCallback onForgotPassword;
  final AuthTextFieldColors textFieldColors;
  final Color linkColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AuthTextField(
          controller: emailController,
          label: 'Email',
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          colors: textFieldColors,
        ),

        const SizedBox(height: 16),

        AuthTextField(
          controller: passwordController,
          label: 'Password',
          icon: Icons.lock_outline,
          obscureText: obscurePassword,
          colors: textFieldColors,
          suffixIcon: IconButton(
            icon: Icon(
              obscurePassword
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
            ),
            onPressed: onTogglePasswordVisibility,
          ),
        ),

        const SizedBox(height: 16),

        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: onForgotPassword,
            style: TextButton.styleFrom(foregroundColor: linkColor),
            child: const Text('Password dimenticata?'),
          ),
        ),
      ],
    );
  }
}
