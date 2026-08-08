import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../theme/auth_colors.dart';
import '../view_model/reset_password_view_model.dart';
import 'auth_action_button.dart';
import 'auth_text_field.dart';

/// Schermata per il recupero della password.
///
/// Gestisce l'inserimento dell'email e delega validazione e invio
/// del link di recupero a [ResetPasswordViewModel].
class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  ResetPasswordViewModel get _viewModel =>
      context.read<ResetPasswordViewModel>();
  final TextEditingController _emailController = TextEditingController();

  static const ResetPasswordColors _colors = ResetPasswordColors();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendResetLink() async {
    final result = await _viewModel.sendResetLink();

    if (!mounted) return;

    _showMessage(result.message);
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: _colors.snackBarBackgroundColor,
        content: Text(
          message,
          style: TextStyle(color: _colors.snackBarTextColor),
        ),
      ),
    );
  }

  void _goBack() => Navigator.pop(context);

  @override
  Widget build(BuildContext context) {
    return Consumer<ResetPasswordViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          backgroundColor: _colors.backgroundColor,
          body: SafeArea(
            child: SingleChildScrollView(
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
                      color: _colors.primaryColor,
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
                      color: _colors.descriptionColor,
                    ),
                  ),

                  const SizedBox(height: 40),

                  AuthTextField(
                    controller: _emailController,
                    onChanged: viewModel.updateEmail,
                    label: 'La tua email',
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    colors: _colors.textFieldColors,
                  ),

                  const SizedBox(height: 24),

                  AuthActionButton(
                    label: viewModel.isSubmitting
                        ? 'Invio in corso...'
                        : 'Invia link di recupero',
                    onPressed: viewModel.canSubmit ? _sendResetLink : null,
                    height: 56,
                    fontSize: 17,
                    borderRadius: 18,
                    colors: _colors.actionButtonColors,
                  ),

                  const SizedBox(height: 32),

                  TextButton.icon(
                    onPressed: _goBack,
                    style: TextButton.styleFrom(
                      foregroundColor: _colors.primaryColor,
                    ),
                    icon: const Icon(Icons.arrow_back),
                    label: const Text(
                      'Torna ad Accedi',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
