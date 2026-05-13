import 'package:flutter/material.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();

  bool _hasEmail = false;

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
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF191970);
    const Color fieldColor = Color(0xFFF1F4FA);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 70),

              // Titolo schermata
              const Text(
                'Password dimenticata?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),

              const SizedBox(height: 16),

              // Descrizione
              Text(
                'Inserisci l’email associata al tuo account. '
                'Ti invieremo un link per reimpostare la password.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  color: Colors.grey.shade700,
                ),
              ),

              const SizedBox(height: 40),

              // Campo email
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                onChanged: (value) {
                  setState(() {
                    _hasEmail = value.trim().isNotEmpty;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'La tua email',
                  prefixIcon: const Icon(Icons.email_outlined),
                  filled: true,
                  fillColor: fieldColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Bottone invio link
              SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: _hasEmail ? _sendResetLink : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey.shade300,
                    disabledForegroundColor: Colors.white,
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

              // Ritorno alla schermata precedente
              TextButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
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