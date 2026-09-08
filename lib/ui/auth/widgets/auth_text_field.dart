import 'package:flutter/material.dart';

import '../theme/auth_colors.dart';

/// Campo input riutilizzabile della feature auth.
class AuthTextField extends StatelessWidget {
  const AuthTextField({
    super.key,
    this.controller,
    required this.label,
    required this.icon,
    this.keyboardType,
    this.obscureText = false,
    this.onChanged,
    this.onToggleObscureText,
  });

  final TextEditingController? controller;
  final String label;
  final IconData icon;
  final TextInputType? keyboardType;
  final bool obscureText;
  final VoidCallback? onToggleObscureText;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: AuthColors.secondaryTextColor),
        prefixIcon: Icon(icon, color: AuthColors.textFieldIconColor),
        suffixIcon: onToggleObscureText == null
            ? null
            : IconButton(
                tooltip: obscureText ? 'Mostra password' : 'Nascondi password',
                onPressed: onToggleObscureText,
                icon: Icon(
                  obscureText
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
              ),
        suffixIconColor: AuthColors.textFieldIconColor,
        filled: true,
        fillColor: AuthColors.textFieldBackgroundColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: AuthColors.primaryColor, width: 1.2),
        ),
      ),
    );
  }
}
