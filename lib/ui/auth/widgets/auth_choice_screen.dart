import 'package:flutter/material.dart';

import '../../../routing/app_routes.dart';
import '../../core/widgets/app_segmented_control.dart';

enum AuthMode { login, register }

class AuthChoiceScreen extends StatefulWidget {
  const AuthChoiceScreen({super.key});

  @override
  State<AuthChoiceScreen> createState() => _AuthChoiceScreenState();
}

class _AuthChoiceScreenState extends State<AuthChoiceScreen> {
  // Stato dello switch Accedi / Registrati.
  AuthMode _selectedMode = AuthMode.login;

  // Controller dei campi del form.
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // Stato visibilità password.
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // Palette privata della schermata auth.
  static const _AuthChoiceColors _colors = _AuthChoiceColors();

  bool get _isLogin => _selectedMode == AuthMode.login;

  String get _primaryButtonText {
    return _isLogin ? 'Accedi' : 'Registrati';
  }

  @override
  void dispose() {
    // Pulizia controller.
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Cambio modalità Accedi / Registrati.
  void _onAuthModeChanged(AuthMode mode) {
    setState(() {
      _selectedMode = mode;
    });
  }

  // Azione del bottone principale.
  void _submit() {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (_isLogin) {
      if (email.isEmpty || password.isEmpty) {
        _showMessage('Inserisci email e password');
        return;
      }

      Navigator.pushReplacementNamed(context, AppRoutes.home);
      return;
    }

    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      _showMessage('Compila tutti i campi');
      return;
    }

    if (password != confirmPassword) {
      _showMessage('Le password non coincidono');
      return;
    }

    Navigator.pushReplacementNamed(context, AppRoutes.home);
  }

  // Accesso come guest.
  void _continueAsGuest() {
    Navigator.pushReplacementNamed(context, AppRoutes.home);
  }

  // Social login fittizio.
  void _fakeSocialLogin(String provider) {
    _showMessage('Accesso con $provider non ancora implementato');
  }

  // Messaggio rapido.
  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Schermata auth senza AppBar.
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
              // Usa colori propri della schermata auth.
              AppSegmentedControl<AuthMode>(
                selectedValue: _selectedMode,
                onChanged: _onAuthModeChanged,
                colors: AppSegmentedControlColors(
                  backgroundColor: _colors.fieldBackgroundColor,
                  selectedColor: _colors.segmentedSelectedColor,
                  borderColor: _colors.segmentedBorderColor,
                  selectedTextColor: _colors.primaryColor,
                  unselectedTextColor: _colors.segmentedUnselectedTextColor,
                  badgeBackgroundColor: _colors.segmentedBadgeBackgroundColor,
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

              // Titolo form centrato.
              Text(
                _isLogin ? 'Bentornato' : 'Crea account',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: _colors.primaryColor,
                ),
              ),

              const SizedBox(height: 10),

              // Sottotitolo form centrato.
              Text(
                _isLogin
                    ? 'Accedi per salvare linee e ricevere notifiche.'
                    : 'Registrati per personalizzare la tua esperienza.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _colors.subtitleColor,
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 30),

              // Campo nome solo per registrazione.
              if (!_isLogin) ...[
                _authTextField(
                  controller: _nameController,
                  label: 'Nome',
                  icon: Icons.person_outline,
                ),
                const SizedBox(height: 16),
              ],

              // Campo email.
              _authTextField(
                controller: _emailController,
                label: 'Email',
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 16),

              // Campo password.
              _authTextField(
                controller: _passwordController,
                label: 'Password',
                icon: Icons.lock_outline,
                obscureText: _obscurePassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                  color: _colors.fieldIconColor,
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),

              const SizedBox(height: 16),

              // Conferma password solo per registrazione.
              if (!_isLogin) ...[
                _authTextField(
                  controller: _confirmPasswordController,
                  label: 'Conferma password',
                  icon: Icons.lock_outline,
                  obscureText: _obscureConfirmPassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                    color: _colors.fieldIconColor,
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Password dimenticata solo per login.
              if (_isLogin)
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.resetPassword);
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: _colors.primaryColor,
                    ),
                    child: const Text('Password dimenticata?'),
                  ),
                ),

              const SizedBox(height: 18),

              // Bottone principale Accedi / Registrati.
              _AuthActionButton(
                label: _primaryButtonText,
                onPressed: _submit,
                backgroundColor: _colors.buttonBackgroundColor,
                foregroundColor: _colors.primaryColor,
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
              Row(
                children: [
                  Expanded(
                    child: _socialButton(
                      label: 'Google',
                      iconWidget: const Text(
                        'G',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () => _fakeSocialLogin('Google'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _socialButton(
                      label: 'Apple',
                      iconWidget: const Icon(Icons.apple_rounded, size: 18),
                      onPressed: () => _fakeSocialLogin('Apple'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _socialButton(
                      label: 'Facebook',
                      iconWidget: const Icon(Icons.facebook_rounded, size: 18),
                      onPressed: () => _fakeSocialLogin('Facebook'),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 26),

              // Bottone guest.
              _AuthActionButton(
                label: 'Continua come guest',
                onPressed: _continueAsGuest,
                height: 54,
                fontSize: 17,
                borderRadius: 26,
                backgroundColor: _colors.buttonBackgroundColor,
                foregroundColor: _colors.primaryColor,
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
  }

  // Campo input riutilizzabile della schermata auth.
  Widget _authTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      cursorColor: _colors.primaryColor,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: _colors.fieldLabelColor),
        prefixIcon: Icon(icon, color: _colors.fieldIconColor),
        suffixIcon: suffixIcon,
        suffixIconColor: _colors.fieldIconColor,
        filled: true,
        fillColor: _colors.fieldBackgroundColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: _colors.primaryColor, width: 1.2),
        ),
      ),
    );
  }

  // Bottone social riutilizzabile.
  Widget _socialButton({
    required String label,
    required Widget iconWidget,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      height: 48,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: _colors.primaryColor,
          side: BorderSide(color: _colors.socialButtonBorderColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconTheme(
              data: IconThemeData(color: _colors.primaryColor),
              child: iconWidget,
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Bottone interno alla schermata auth.
// Serve per evitare duplicazione tra bottone principale e bottone guest.
class _AuthActionButton extends StatelessWidget {
  const _AuthActionButton({
    required this.label,
    required this.onPressed,
    required this.backgroundColor,
    required this.foregroundColor,
    this.height = 58,
    this.fontSize = 18,
    this.borderRadius = 28,
  });

  final String label;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color foregroundColor;
  final double height;
  final double fontSize;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

// Palette privata della schermata auth.
// Qui stanno tutti i colori usati da login/registrazione.
class _AuthChoiceColors {
  const _AuthChoiceColors();

  final Color backgroundColor = Colors.white;

  final Color primaryColor = const Color(0xFF191970);

  final Color screenTitleColor = const Color(0xFF111827);

  final Color subtitleColor = const Color(0xFF4B5563);

  final Color helperTextColor = const Color(0xFF6B7280);

  final Color buttonBackgroundColor = const Color(0xFFF7F9FC);

  final Color fieldBackgroundColor = const Color(0xFFF1F4FA);

  final Color fieldLabelColor = const Color(0xFF4B5563);

  final Color fieldIconColor = const Color(0xFF5D6675);

  final Color dividerColor = const Color(0xFFD1D5DB);

  final Color separatorTextColor = const Color(0xFF6B7280);

  final Color socialButtonBorderColor = const Color(0xFF9CA3AF);

  final Color segmentedSelectedColor = Colors.white;

  final Color segmentedBorderColor = const Color(0xFFE1E7F0);

  final Color segmentedUnselectedTextColor = const Color(0xFF4B5563);

  final Color segmentedBadgeBackgroundColor = const Color(0xFFE8EAFF);

  final Color segmentedSelectedBadgeBackgroundColor = const Color(0x2EFFFFFF);
}