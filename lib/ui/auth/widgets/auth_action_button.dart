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
    this.backgroundColor = AuthColors.actionButtonBackgroundColor,
    this.foregroundColor = AuthColors.actionButtonForegroundColor,
  });

  final String label;
  final VoidCallback? onPressed;
  final double height;
  final double fontSize;
  final double borderRadius;
  final Color backgroundColor;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          disabledBackgroundColor: AuthColors.disabledButtonBackgroundColor,
          disabledForegroundColor: AuthColors.disabledButtonForegroundColor,
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
