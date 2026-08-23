import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../theme/auth_colors.dart';
import '../view_model/reset_password_view_model.dart';
import 'auth_action_button.dart';
import 'auth_text_field.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  Future<void> _sendResetLink(BuildContext context) async {
    final message = await context
        .read<ResetPasswordViewModel>()
        .sendResetLink();

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AuthColors.snackBarBackgroundColor,
        content: Text(
          message,
          style: TextStyle(color: AuthColors.snackBarTextColor),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ResetPasswordViewModel>();

    return Scaffold(
      backgroundColor: AuthColors.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 70),

              Text(
                'Password dimenticata?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: AuthColors.primaryColor,
                ),
              ),

              const SizedBox(height: 16),

              Text(
                'Inserisci l’email associata al tuo account. '
                'Ti invieremo un link per reimpostare la password.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  color: AuthColors.secondaryTextColor,
                ),
              ),

              const SizedBox(height: 40),

              AuthTextField(
                onChanged: viewModel.updateEmail,
                label: 'La tua email',
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 24),

              AuthActionButton(
                label: viewModel.isSubmitting
                    ? 'Invio in corso...'
                    : 'Invia link di recupero',
                onPressed: viewModel.canSubmit
                    ? () => _sendResetLink(context)
                    : null,
                height: 56,
                fontSize: 17,
                borderRadius: 18,
                backgroundColor: AuthColors.primaryColor,
                foregroundColor: AuthColors.backgroundColor,
              ),

              const SizedBox(height: 32),

              TextButton.icon(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  foregroundColor: AuthColors.primaryColor,
                ),
                icon: const Icon(Icons.arrow_back),
                label: const Text(
                  'Torna ad Accedi',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
