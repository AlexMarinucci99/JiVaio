import 'package:flutter/material.dart';

import '../../../routing/app_routes.dart';
import '../../core/widgets/app_segmented_control.dart';

enum AuthMode {
  login,
  register,
}

class AuthChoiceScreen extends StatefulWidget {
  const AuthChoiceScreen({super.key});

  @override
  State<AuthChoiceScreen> createState() => _AuthChoiceScreenState();
}

class _AuthChoiceScreenState extends State<AuthChoiceScreen> {
  // Stato dello switch Accedi / Registrati
  AuthMode _selectedMode = AuthMode.login;

  // Controller campi
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // Stato visibilità password
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  bool get _isLogin => _selectedMode == AuthMode.login;

  String get _primaryButtonText {
    return _isLogin ? 'Accedi' : 'Registrati';
  }

  @override
  void dispose() {
    // Pulizia controller
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Cambio modalità Accedi / Registrati
  void _onAuthModeChanged(AuthMode mode) {
    setState(() {
      _selectedMode = mode;
    });
  }

  // Azione fittizia del bottone principale
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

  // Accesso come guest
  void _continueAsGuest() {
    Navigator.pushReplacementNamed(context, AppRoutes.home);
  }

  // Social login fittizio
  void _fakeSocialLogin(String provider) {
    _showMessage('Accesso con $provider non ancora implementato');
  }

  // Messaggio rapido
  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF191970);

    return Scaffold(
      appBar: AppBar(
        title: const Text('WayLine'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),

              // Titolo schermata
              const Text(
                'Come vuoi continuare?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 32),

              // Switch Accedi / Registrati
              AppSegmentedControl<AuthMode>(
                selectedValue: _selectedMode,
                onChanged: _onAuthModeChanged,
                selectedColor: Colors.white,
                backgroundColor: const Color(0xFFF1F4FA),
                borderColor: const Color(0xFFE1E7F0),
                selectedTextColor: primaryColor,
                unselectedTextColor: const Color(0xFF4B5563),
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

              const SizedBox(height: 32),

              // Titolo form
              Text(
                _isLogin ? 'Bentornato!' : 'Crea account',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),

              const SizedBox(height: 8),

              // Sottotitolo form
              Text(
                _isLogin
                    ? 'Accedi per salvare linee e ricevere notifiche.'
                    : 'Registrati per personalizzare la tua esperienza.',
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 28),

              // Campo nome solo per registrazione
              if (!_isLogin) ...[
                _authTextField(
                  controller: _nameController,
                  label: 'Nome',
                  icon: Icons.person_outline,
                ),
                const SizedBox(height: 16),
              ],

              // Campo email
              _authTextField(
                controller: _emailController,
                label: 'Email',
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 16),

              // Campo password
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
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),

              const SizedBox(height: 16),

              // Conferma password solo per registrazione
              if (!_isLogin) ...[
                _authTextField(
                  controller: _confirmPasswordController,
                  label: 'Conferma password',
                  icon: Icons.lock_reset_outlined,
                  obscureText: _obscureConfirmPassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Password dimenticata solo per login
              if (_isLogin)
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.resetPassword);
                    },
                    child: const Text('Password dimenticata?'),
                  ),
                ),

              const SizedBox(height: 16),

              // Bottone principale
              SizedBox(
                height: 54,
                child: ElevatedButton(
                  onPressed: _submit,
                  child: Text(_primaryButtonText),
                ),
              ),

              const SizedBox(height: 28),

              // Separatore
              Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey.shade300)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      'oppure',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ),
                  Expanded(child: Divider(color: Colors.grey.shade300)),
                ],
              ),

              const SizedBox(height: 20),

              // Bottoni social fittizi
              Row(
                children: [
                  Expanded(
                    child: _socialButton(
                      label: 'Google',
                      icon: Icons.g_mobiledata_rounded,
                      onPressed: () => _fakeSocialLogin('Google'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _socialButton(
                      label: 'Apple',
                      icon: Icons.apple_rounded,
                      onPressed: () => _fakeSocialLogin('Apple'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _socialButton(
                      label: 'Facebook',
                      icon: Icons.facebook_rounded,
                      onPressed: () => _fakeSocialLogin('Facebook'),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // Accesso ospite
              TextButton(
                onPressed: _continueAsGuest,
                child: const Text('Continua come guest'),
              ),

              Text(
                'Senza salvataggi e notifiche personalizzate',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Campo input riutilizzabile
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
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: const Color(0xFFF1F4FA),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  // Bottone social fittizio
  Widget _socialButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(
        label,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}