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
  // Stato locale del segmented control.
  AuthMode _selectedMode = AuthMode.login;

  // Testo del bottone principale in base alla tab selezionata.
  String get _primaryButtonText {
    if (_selectedMode == AuthMode.login) {
      return 'Accedi';
    }

    return 'Registrati';
  }

  // Rotta da aprire in base alla tab selezionata.
  String get _selectedRoute {
    if (_selectedMode == AuthMode.login) {
      return AppRoutes.login;
    }

    return AppRoutes.register;
  }

  // Cambio modalità: Accedi / Registrati.
  void _onAuthModeChanged(AuthMode mode) {
    if (_selectedMode == mode) return;

    setState(() {
      _selectedMode = mode;
    });
  }

  // Navigazione verso Login o Registrazione.
  void _goToSelectedAuthPage() {
    Navigator.pushNamed(context, _selectedRoute);
  }

  // Accesso come guest.
  void _continueAsGuest() {
    Navigator.pushReplacementNamed(context, AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WayLine'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Titolo schermata.
            const Text(
              'Come vuoi continuare?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 32),

            // Widget riutilizzabile: switch Accedi / Registrati.
            AppSegmentedControl<AuthMode>(
              selectedValue: _selectedMode,
              onChanged: _onAuthModeChanged,
              selectedColor: Colors.white,
              backgroundColor: const Color(0xFFF1F4FA),
              borderColor: const Color(0xFFE1E7F0),
              selectedTextColor: const Color(0xFF20268F),
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

            // Bottone principale dinamico.
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _goToSelectedAuthPage,
                child: Text(_primaryButtonText),
              ),
            ),

            const SizedBox(height: 12),

            // Bottone guest.
            TextButton(
              onPressed: _continueAsGuest,
              child: const Text('Continua come guest'),
            ),
          ],
        ),
      ),
    );
  }
}