import 'package:flutter/material.dart';

import '../view_model/reset_password_view_model.dart';
import 'auth_action_button.dart';
import 'auth_text_field.dart';
import '../../../data/repositories/auth_repository.dart';
import '../theme/reset_password_colors.dart';

/// Schermata per il recupero della password.
///
/// Gestisce l'inserimento dell'email e delega validazione e invio
/// del link di recupero a [ResetPasswordViewModel].
class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key, required this.authRepository});

  /// Repository usato dal ViewModel per inviare il link di recupero.
  final AuthRepository authRepository;

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  late final ResetPasswordViewModel _viewModel;
  final TextEditingController _emailController = TextEditingController();

  static const ResetPasswordColors _colors = ResetPasswordColors();

  @override
  void initState() {
    super.initState();

    _viewModel = ResetPasswordViewModel(widget.authRepository);
    _emailController.addListener(_onEmailChanged);
  }

  @override
  void dispose() {
    _emailController.removeListener(_onEmailChanged);
    _emailController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  void _onEmailChanged() {
    _viewModel.updateEmail(_emailController.text);
  }

  Future<void> _sendResetLink() async {
    final result = await _viewModel.sendResetLink();

    if (!mounted) {
      return;
    }

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

  void _goBack() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _viewModel,
      builder: (context, child) {
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
                    label: 'La tua email',
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    colors: _colors.textFieldColors,
                  ),

                  const SizedBox(height: 24),

                  AuthActionButton(
                    label: _viewModel.isSubmitting
                        ? 'Invio in corso...'
                        : 'Invia link di recupero',
                    onPressed: _viewModel.canSubmit ? _sendResetLink : null,
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
