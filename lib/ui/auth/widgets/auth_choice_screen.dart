import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../routing/app_routes.dart';
import '../../core/widgets/app_segmented_control.dart';
import '../view_model/auth_view_model.dart';
import 'auth_action_button.dart';
import 'auth_login_form.dart';
import 'auth_register_form.dart';
import 'auth_social_buttons.dart';
import '../theme/auth_colors.dart';

/// Schermata di scelta tra accesso, registrazione e modalità ospite.
///
/// Gestisce la View della feature auth e delega stato, validazione
/// e operazioni di autenticazione ad [AuthViewModel].
class AuthChoiceScreen extends StatefulWidget {
  const AuthChoiceScreen({super.key, required this.onContinueAsGuest});

  final VoidCallback onContinueAsGuest;

  @override
  State<AuthChoiceScreen> createState() => _AuthChoiceScreenState();
}

class _AuthChoiceScreenState extends State<AuthChoiceScreen> {
  AuthViewModel get _viewModel => context.read<AuthViewModel>();

  /// I controller restano nella View perché sono risorse UI con lifecycle.
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_viewModel.isSubmitting) return;

    final message = await _viewModel.submit(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      confirmPassword: _confirmPasswordController.text.trim(),
    );

    if (!mounted) return;

    if (message != null) {
      _showMessage(message);
    }

    // La navigazione alla Home resta responsabilità di AuthGate.
    // Firebase aggiorna authStateChanges() dopo login o registrazione.
  }

  void _continueAsGuest() {
    if (_viewModel.isSubmitting) return;

    widget.onContinueAsGuest();
  }

  Future<void> _signInWithGoogle() async {
    if (_viewModel.isSubmitting) return;

    final message = await _viewModel.signInWithGoogle();

    if (!mounted) return;

    if (message != null) {
      _showMessage(message);
    }

    // La navigazione alla Home resta responsabilità di AuthGate.
    // Firebase aggiorna authStateChanges() dopo il login Google.
  }

  void _fakeSocialLogin(String provider) {
    if (_viewModel.isSubmitting) return;

    _showMessage('Accesso con $provider non ancora implementato');
  }

  void _showMessage(String message) => ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text(message)));

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AuthViewModel>();

    return Scaffold(
      backgroundColor: AuthColors.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 28),

              Text(
                'Come vuoi continuare?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AuthColors.screenTitleColor,
                ),
              ),

              const SizedBox(height: 32),

              AppSegmentedControl<AuthMode>(
                selectedValue: viewModel.selectedMode,
                onChanged: viewModel.setMode,
                colors: AuthColors.segmentedControlColors,
                items: const [
                  AppSegmentedControlItem(
                    value: AuthMode.login,
                    label: 'Accedi',
                  ),
                  AppSegmentedControlItem(
                    value: AuthMode.register,
                    label: 'Registrati',
                  ),
                ],
              ),

              const SizedBox(height: 36),

              Text(
                viewModel.formTitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: AuthColors.primaryColor,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                viewModel.formSubtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AuthColors.secondaryTextColor,
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 30),

              if (viewModel.isLogin)
                AuthLoginForm(
                  emailController: _emailController,
                  passwordController: _passwordController,
                  obscurePassword: viewModel.obscurePassword,
                  onTogglePasswordVisibility:
                      viewModel.togglePasswordVisibility,
                  onForgotPassword: () =>
                      Navigator.pushNamed(context, AppRoutes.resetPassword),
                )
              else
                AuthRegisterForm(
                  nameController: _nameController,
                  emailController: _emailController,
                  passwordController: _passwordController,
                  confirmPasswordController: _confirmPasswordController,
                  obscurePassword: viewModel.obscurePassword,
                  obscureConfirmPassword: viewModel.obscureConfirmPassword,
                  onTogglePasswordVisibility:
                      viewModel.togglePasswordVisibility,
                  onToggleConfirmPasswordVisibility:
                      viewModel.toggleConfirmPasswordVisibility,
                ),

              const SizedBox(height: 18),

              AuthActionButton(
                label: viewModel.primaryButtonText,
                onPressed: viewModel.isSubmitting ? null : _submit,
              ),

              const SizedBox(height: 30),

              Row(
                children: [
                  Expanded(child: Divider(color: AuthColors.dividerColor)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      'oppure',
                      style: TextStyle(color: AuthColors.mutedTextColor),
                    ),
                  ),
                  Expanded(child: Divider(color: AuthColors.dividerColor)),
                ],
              ),

              const SizedBox(height: 20),

              AuthSocialButtons(
                onGooglePressed: _signInWithGoogle,
                onApplePressed: () => _fakeSocialLogin('Apple'),
                onFacebookPressed: () => _fakeSocialLogin('Facebook'),
              ),

              const SizedBox(height: 26),

              AuthActionButton(
                label: 'Continua come ospite',
                onPressed: viewModel.isSubmitting ? null : _continueAsGuest,
                height: 54,
                fontSize: 17,
                borderRadius: 26,
              ),

              const SizedBox(height: 10),

              Text(
                'Senza salvataggi e notifiche personalizzate',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AuthColors.mutedTextColor,
                  fontSize: 13,
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
