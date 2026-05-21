import 'package:flutter/material.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();

  bool _hasEmail = false;

  // Palette privata della schermata reset password.
  static const _ResetPasswordColors _colors = _ResetPasswordColors();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _sendResetLink() {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      _showMessage('Inserisci la tua email');
      return;
    }

    // Simulazione provvisoria.
    // In seguito qui useremo Firebase Auth.
    _showMessage('Link di recupero inviato a $email');
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: _colors.snackBarBackgroundColor,
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  void _goBack() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
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

              // Campo email.
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                cursorColor: _colors.primaryColor,
                onChanged: (value) {
                  setState(() {
                    _hasEmail = value.trim().isNotEmpty;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'La tua email',
                  labelStyle: TextStyle(color: _colors.fieldLabelColor),
                  prefixIcon: Icon(
                    Icons.email_outlined,
                    color: _colors.fieldIconColor,
                  ),
                  filled: true,
                  fillColor: _colors.fieldBackgroundColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide(
                      color: _colors.primaryColor,
                      width: 1.2,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Bottone invio link.
              SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: _hasEmail ? _sendResetLink : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _colors.primaryColor,
                    foregroundColor: _colors.buttonTextColor,
                    disabledBackgroundColor: _colors.disabledButtonColor,
                    disabledForegroundColor: _colors.disabledButtonTextColor,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: const Text(
                    'Invia link di recupero',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
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
  }
}

// Palette privata della schermata reset password.
// Tiene separati i colori della feature auth dal tema globale.
class _ResetPasswordColors {
  const _ResetPasswordColors();

  final Color backgroundColor = Colors.white;

  final Color primaryColor = const Color(0xFF191970);

  final Color descriptionColor = const Color(0xFF4B5563);

  final Color fieldBackgroundColor = const Color(0xFFF1F4FA);

  final Color fieldLabelColor = const Color(0xFF4B5563);

  final Color fieldIconColor = const Color(0xFF5D6675);

  final Color buttonTextColor = Colors.white;

  final Color disabledButtonColor = const Color(0xFFE5E7EB);

  final Color disabledButtonTextColor = Colors.white;

  final Color snackBarBackgroundColor = const Color(0xFF061A3A);
}