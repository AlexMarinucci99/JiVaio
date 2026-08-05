import 'package:flutter/material.dart';

import '../theme/auth_colors.dart';
import 'auth_text_field.dart';

/// Form di registrazione della feature auth.
class AuthRegisterForm extends StatelessWidget {
  const AuthRegisterForm({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.obscurePassword,
    required this.obscureConfirmPassword,
    required this.onTogglePasswordVisibility,
    required this.onToggleConfirmPasswordVisibility,
    this.textFieldColors = const AuthTextFieldColors(),
  });

  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final bool obscurePassword;
  final bool obscureConfirmPassword;
  final VoidCallback onTogglePasswordVisibility;
  final VoidCallback onToggleConfirmPasswordVisibility;
  final AuthTextFieldColors textFieldColors;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AuthTextField(
          controller: nameController,
          label: 'Nome',
          icon: Icons.person_outline,
          colors: textFieldColors,
        ),

        const SizedBox(height: 16),

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
          onToggleObscureText: onTogglePasswordVisibility,
        ),

        const SizedBox(height: 16),

        AuthTextField(
          controller: confirmPasswordController,
          label: 'Conferma password',
          icon: Icons.lock_outline,
          obscureText: obscureConfirmPassword,
          colors: textFieldColors,
          onToggleObscureText: onToggleConfirmPasswordVisibility,
        ),
      ],
    );
  }
}
