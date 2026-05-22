import 'package:flutter/material.dart';

class AuthTextFieldColors {
  const AuthTextFieldColors({
    this.primaryColor = const Color(0xFF191970),
    this.backgroundColor = const Color(0xFFF1F4FA),
    this.labelColor = const Color(0xFF4B5563),
    this.iconColor = const Color(0xFF5D6675),
  });

  final Color primaryColor;
  final Color backgroundColor;
  final Color labelColor;
  final Color iconColor;
}

// Campo input riutilizzabile della feature auth.
class AuthTextField extends StatelessWidget {
  const AuthTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.keyboardType,
    this.obscureText = false,
    this.suffixIcon,
    this.colors = const AuthTextFieldColors(),
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;
  final AuthTextFieldColors colors;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      cursorColor: colors.primaryColor,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: colors.labelColor),
        prefixIcon: Icon(icon, color: colors.iconColor),
        suffixIcon: suffixIcon,
        suffixIconColor: colors.iconColor,
        filled: true,
        fillColor: colors.backgroundColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: colors.primaryColor,
            width: 1.2,
          ),
        ),
      ),
    );
  }
}