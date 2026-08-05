import 'package:flutter/material.dart';

import '../theme/auth_colors.dart';

/// Bottone d'azione della feature auth.
///
/// Usato per Accedi, Registrati e Continua come guest.
class AuthActionButton extends StatelessWidget {
  const AuthActionButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.height = 58,
    this.fontSize = 18,
    this.borderRadius = 28,
    this.colors = const AuthActionButtonColors(),
  });

  final String label;
  final VoidCallback? onPressed;
  final double height;
  final double fontSize;
  final double borderRadius;
  final AuthActionButtonColors colors;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: colors.backgroundColor,
          foregroundColor: colors.foregroundColor,
          disabledBackgroundColor: colors.disabledBackgroundColor,
          disabledForegroundColor: colors.disabledForegroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
