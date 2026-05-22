import 'package:flutter/material.dart';

class AuthActionButtonColors {
  const AuthActionButtonColors({
    this.backgroundColor = const Color(0xFFF7F9FC),
    this.foregroundColor = const Color(0xFF191970),
    this.disabledBackgroundColor = const Color(0xFFE5E7EB),
    this.disabledForegroundColor = const Color(0xFF9CA3AF),
  });

  final Color backgroundColor;
  final Color foregroundColor;
  final Color disabledBackgroundColor;
  final Color disabledForegroundColor;
}

// Bottone d'azione della feature auth.
// Usato per Accedi, Registrati e Continua come guest.
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
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}