import 'package:flutter/material.dart';

import '../../../data/repositories/auth_repository.dart';
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
  const AuthChoiceScreen({
    super.key,
    required this.authRepository,
    required this.onContinueAsGuest,
  });

  /// Repository usato dal ViewModel per login e registrazione.
  final AuthRepository authRepository;

  /// Callback invocata quando l'utente prosegue senza autenticazione.
  final VoidCallback onContinueAsGuest;

  @override
  State<AuthChoiceScreen> createState() => _AuthChoiceScreenState();
}

class _AuthChoiceScreenState extends State<AuthChoiceScreen> {
  late final AuthViewModel _viewModel;

  /// I controller restano nella View perché sono risorse UI con lifecycle.
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  static const AuthChoiceColors _colors = AuthChoiceColors();

  @override
  void initState() {
    super.initState();
    _viewModel = AuthViewModel(widget.authRepository);
  }

  @override
  void dispose() {
    _viewModel.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _openResetPassword() {
    Navigator.pushNamed(context, AppRoutes.resetPassword);
  }

  Future<void> _submit() async {
    if (_viewModel.isSubmitting) {
      return;
    }

    final result = await _viewModel.submit(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      confirmPassword: _confirmPasswordController.text.trim(),
    );

    if (!mounted) {
      return;
    }

    if (!result.isValid) {
      _showMessage(result.message ?? 'Dati non validi');
    }

    // La navigazione alla Home resta responsabilità di AuthGate.
    // Firebase aggiorna authStateChanges() dopo login o registrazione.
  }

  void _continueAsGuest() {
    if (_viewModel.isSubmitting) {
      return;
    }

    widget.onContinueAsGuest();
  }

  void _setMode(AuthMode mode) {
    if (_viewModel.isSubmitting) {
      return;
    }

    _viewModel.setMode(mode);
  }

  Future<void> _signInWithGoogle() async {
    if (_viewModel.isSubmitting) {
      return;
    }

    final result = await _viewModel.signInWithGoogle();

    if (!mounted) {
      return;
    }

    if (!result.isValid) {
      _showMessage(result.message ?? 'Accesso con Google non riuscito.');
    }

    // La navigazione alla Home resta responsabilità di AuthGate.
    // Firebase aggiorna authStateChanges() dopo il login Google.
  }

  void _fakeSocialLogin(String provider) {
    if (_viewModel.isSubmitting) {
      return;
    }

    _showMessage(_viewModel.socialLoginMessage(provider));
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
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
                  const SizedBox(height: 28),

                  Text(
                    'Come vuoi continuare?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: _colors.screenTitleColor,
                    ),
                  ),

                  const SizedBox(height: 32),

                  AppSegmentedControl<AuthMode>(
                    selectedValue: _viewModel.selectedMode,
                    onChanged: _setMode,
                    colors: _colors.segmentedControlColors,
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
                    _viewModel.formTitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: _colors.primaryColor,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    _viewModel.formSubtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _colors.subtitleColor,
                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(height: 30),

                  if (_viewModel.isLogin)
                    AuthLoginForm(
                      emailController: _emailController,
                      passwordController: _passwordController,
                      obscurePassword: _viewModel.obscurePassword,
                      onTogglePasswordVisibility:
                          _viewModel.togglePasswordVisibility,
                      onForgotPassword: _openResetPassword,
                      textFieldColors: _colors.textFieldColors,
                      linkColor: _colors.primaryColor,
                    )
                  else
                    AuthRegisterForm(
                      nameController: _nameController,
                      emailController: _emailController,
                      passwordController: _passwordController,
                      confirmPasswordController: _confirmPasswordController,
                      obscurePassword: _viewModel.obscurePassword,
                      obscureConfirmPassword: _viewModel.obscureConfirmPassword,
                      onTogglePasswordVisibility:
                          _viewModel.togglePasswordVisibility,
                      onToggleConfirmPasswordVisibility:
                          _viewModel.toggleConfirmPasswordVisibility,
                      textFieldColors: _colors.textFieldColors,
                    ),

                  const SizedBox(height: 18),

                  AuthActionButton(
                    label: _viewModel.primaryButtonText,
                    onPressed: _viewModel.isSubmitting ? null : _submit,
                    colors: _colors.actionButtonColors,
                  ),

                  const SizedBox(height: 30),

                  Row(
                    children: [
                      Expanded(child: Divider(color: _colors.dividerColor)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          'oppure',
                          style: TextStyle(color: _colors.separatorTextColor),
                        ),
                      ),
                      Expanded(child: Divider(color: _colors.dividerColor)),
                    ],
                  ),

                  const SizedBox(height: 20),

                  AuthSocialButtons(
                    colors: _colors.socialButtonsColors,
                    onGooglePressed: _signInWithGoogle,
                    onApplePressed: () => _fakeSocialLogin('Apple'),
                    onFacebookPressed: () => _fakeSocialLogin('Facebook'),
                  ),

                  const SizedBox(height: 26),

                  AuthActionButton(
                    label: 'Continua come ospite',
                    onPressed: _viewModel.isSubmitting
                        ? null
                        : _continueAsGuest,
                    height: 54,
                    fontSize: 17,
                    borderRadius: 26,
                    colors: _colors.actionButtonColors,
                  ),

                  const SizedBox(height: 10),

                  Text(
                    'Senza salvataggi e notifiche personalizzate',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _colors.helperTextColor,
                      fontSize: 13,
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
