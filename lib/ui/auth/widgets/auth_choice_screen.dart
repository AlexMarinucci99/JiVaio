import 'package:flutter/material.dart';

import '../../../data/repositories/auth_repository.dart';
import '../../../routing/app_routes.dart';
import '../../core/widgets/app_segmented_control.dart';
import '../view_model/auth_view_model.dart';
import 'auth_action_button.dart';
import 'auth_login_form.dart';
import 'auth_register_form.dart';
import 'auth_social_buttons.dart';
import 'auth_text_field.dart';

class AuthChoiceScreen extends StatefulWidget {
  const AuthChoiceScreen({
    super.key,
    required this.authRepository,
    required this.onContinueAsGuest,
  });

  final AuthRepository authRepository;
  final VoidCallback onContinueAsGuest;

  @override
  State<AuthChoiceScreen> createState() => _AuthChoiceScreenState();
}

class _AuthChoiceScreenState extends State<AuthChoiceScreen> {
  late final AuthViewModel _viewModel;

  // Controller dei campi del form.
  // Restano nella View perché sono risorse UI con lifecycle.
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  static const _AuthChoiceColors _colors = _AuthChoiceColors();

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

    // Non navighiamo alla Home qui.
    // Se login/registrazione vanno a buon fine,
    // Firebase aggiorna authStateChanges() e sarà AuthGate a mostrare la Home.
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

  void _fakeSocialLogin(String provider) {
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

                  // Titolo schermata.
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

                  // Switch Accedi / Registrati.
                  AppSegmentedControl<AuthMode>(
                    selectedValue: _viewModel.selectedMode,
                    onChanged: _setMode,
                    colors: AppSegmentedControlColors(
                      backgroundColor: _colors.fieldBackgroundColor,
                      selectedColor: _colors.segmentedSelectedColor,
                      borderColor: _colors.segmentedBorderColor,
                      selectedTextColor: _colors.primaryColor,
                      unselectedTextColor: _colors.segmentedUnselectedTextColor,
                      badgeBackgroundColor:
                          _colors.segmentedBadgeBackgroundColor,
                      badgeTextColor: _colors.primaryColor,
                      selectedBadgeBackgroundColor:
                          _colors.segmentedSelectedBadgeBackgroundColor,
                      selectedBadgeTextColor: _colors.primaryColor,
                    ),
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

                  // Titolo form.
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

                  // Sottotitolo form.
                  Text(
                    _viewModel.formSubtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _colors.subtitleColor,
                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Form dinamico: login oppure registrazione.
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
                      obscureConfirmPassword:
                          _viewModel.obscureConfirmPassword,
                      onTogglePasswordVisibility:
                          _viewModel.togglePasswordVisibility,
                      onToggleConfirmPasswordVisibility:
                          _viewModel.toggleConfirmPasswordVisibility,
                      textFieldColors: _colors.textFieldColors,
                    ),

                  const SizedBox(height: 18),

                  // Bottone principale Accedi / Registrati.
                  AuthActionButton(
                    label: _viewModel.primaryButtonText,
                    onPressed: _submit,
                    colors: _colors.actionButtonColors,
                  ),

                  const SizedBox(height: 30),

                  // Separatore.
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

                  // Bottoni social.
                  AuthSocialButtons(
                    colors: _colors.socialButtonsColors,
                    onGooglePressed: () => _fakeSocialLogin('Google'),
                    onApplePressed: () => _fakeSocialLogin('Apple'),
                    onFacebookPressed: () => _fakeSocialLogin('Facebook'),
                  ),

                  const SizedBox(height: 26),

                  // Bottone guest.
                  AuthActionButton(
                    label: 'Continua come ospite',
                    onPressed: _continueAsGuest,
                    height: 54,
                    fontSize: 17,
                    borderRadius: 26,
                    colors: _colors.actionButtonColors,
                  ),

                  const SizedBox(height: 10),

                  // Nota sotto il guest.
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

class _AuthChoiceColors {
  const _AuthChoiceColors();

  final Color backgroundColor = Colors.white;

  final Color primaryColor = const Color(0xFF191970);

  final Color screenTitleColor = const Color(0xFF111827);

  final Color subtitleColor = const Color(0xFF4B5563);

  final Color helperTextColor = const Color(0xFF6B7280);

  final Color fieldBackgroundColor = const Color(0xFFF1F4FA);

  final Color dividerColor = const Color(0xFFD1D5DB);

  final Color separatorTextColor = const Color(0xFF6B7280);

  final Color segmentedSelectedColor = Colors.white;

  final Color segmentedBorderColor = const Color(0xFFE1E7F0);

  final Color segmentedUnselectedTextColor = const Color(0xFF4B5563);

  final Color segmentedBadgeBackgroundColor = const Color(0xFFE8EAFF);

  final Color segmentedSelectedBadgeBackgroundColor = const Color(0x2EFFFFFF);

  final AuthTextFieldColors textFieldColors = const AuthTextFieldColors(
    primaryColor: Color(0xFF191970),
    backgroundColor: Color(0xFFF1F4FA),
    labelColor: Color(0xFF4B5563),
    iconColor: Color(0xFF5D6675),
  );

  final AuthActionButtonColors actionButtonColors = const AuthActionButtonColors(
    backgroundColor: Color(0xFFF7F9FC),
    foregroundColor: Color(0xFF191970),
    disabledBackgroundColor: Color(0xFFE5E7EB),
    disabledForegroundColor: Color(0xFF9CA3AF),
  );

  final AuthSocialButtonsColors socialButtonsColors =
      const AuthSocialButtonsColors(
        foregroundColor: Color(0xFF191970),
        borderColor: Color(0xFF9CA3AF),
      );
}