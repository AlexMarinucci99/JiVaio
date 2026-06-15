import 'package:flutter/material.dart';

import '../widgets/auth_action_button.dart';
import '../widgets/auth_text_field.dart';

/// Palette della schermata di recupero password.
///
/// È separata dalla View per mantenere ResetPasswordScreen concentrata
/// su struttura UI, gestione controller e interazione con il ViewModel.
class ResetPasswordColors {
  const ResetPasswordColors();

  final Color backgroundColor = Colors.white;

  final Color primaryColor = const Color(0xFF191970);

  final Color descriptionColor = const Color(0xFF4B5563);

  final Color snackBarBackgroundColor = const Color(0xFF061A3A);

  final Color snackBarTextColor = Colors.white;

  final AuthTextFieldColors textFieldColors = const AuthTextFieldColors(
    primaryColor: Color(0xFF191970),
    backgroundColor: Color(0xFFF1F4FA),
    labelColor: Color(0xFF4B5563),
    iconColor: Color(0xFF5D6675),
  );

  final AuthActionButtonColors actionButtonColors =
      const AuthActionButtonColors(
        backgroundColor: Color(0xFF191970),
        foregroundColor: Colors.white,
        disabledBackgroundColor: Color(0xFFE5E7EB),
        disabledForegroundColor: Color(0xFF9CA3AF),
      );
}