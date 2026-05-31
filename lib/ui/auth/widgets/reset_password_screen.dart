import 'package:flutter/material.dart';

import '../view_model/reset_password_view_model.dart';
import 'auth_action_button.dart';
import 'auth_text_field.dart';
import '../../../data/repositories/auth_repository.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key, required this.authRepository});

  final AuthRepository authRepository;

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  late final ResetPasswordViewModel _viewModel;
  final TextEditingController _emailController = TextEditingController();

  static const _ResetPasswordColors _colors = _ResetPasswordColors();

  @override
  void initState() {
    super.initState();

    _viewModel = ResetPasswordViewModel(widget.authRepository);

    // Aggiorna il ViewModel quando cambia il testo del campo email.
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

                  // Titolo schermata.
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

                  // Descrizione.
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

                  // Campo email riutilizzabile della feature auth.
                  AuthTextField(
                    controller: _emailController,
                    label: 'La tua email',
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    colors: _colors.textFieldColors,
                  ),

                  const SizedBox(height: 24),

                  // Bottone invio link.
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

                  // Ritorno alla schermata precedente.
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

class _ResetPasswordColors {
  const _ResetPasswordColors();

  final Color backgroundColor = Colors.white;

  final Color primaryColor = const Color(0xFF191970);

  final Color descriptionColor = const Color(0xFF4B5563);

  final Color snackBarBackgroundColor = const Color(0xFF061A3A);

  final Color snackBarTextColor = Colors.white;

  final AuthTextFieldColors textFieldColors = const AuthTextFieldColors(
    primaryColor: Color(0xFF191970),
    backgroundColor: Color(0xFFF1F4FA),
    labelColor: Color(0xFF4B5563),
    iconColor: Color(0xFF5D6675),
  );

  final AuthActionButtonColors actionButtonColors =
      const AuthActionButtonColors(
        backgroundColor: Color(0xFF191970),
        foregroundColor: Colors.white,
        disabledBackgroundColor: Color(0xFFE5E7EB),
        disabledForegroundColor: Color(0xFF9CA3AF),
      );
}
