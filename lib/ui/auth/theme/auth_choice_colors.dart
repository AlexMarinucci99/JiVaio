import 'package:flutter/material.dart';

import '../../core/themes/app_segmented_control_colors.dart';
import '../widgets/auth_action_button.dart';
import '../widgets/auth_social_buttons.dart';
import '../widgets/auth_text_field.dart';

/// Palette della schermata di autenticazione.
///
/// È separata dalla View per mantenere AuthChoiceScreen concentrata
/// sulla struttura UI e non sui dettagli grafici.
class AuthChoiceColors {
  const AuthChoiceColors();

  final Color backgroundColor = Colors.white;

  final Color primaryColor = const Color(0xFF191970);

  final Color screenTitleColor = const Color(0xFF111827);

  final Color subtitleColor = const Color(0xFF4B5563);

  final Color helperTextColor = const Color(0xFF6B7280);

  final Color dividerColor = const Color(0xFFD1D5DB);

  final Color separatorTextColor = const Color(0xFF6B7280);

  final Color backButtonColor = const Color(0xFF6B7280);

  final AppSegmentedControlColors segmentedControlColors =
      AppSegmentedControlColors.auth;

  final AuthTextFieldColors textFieldColors = const AuthTextFieldColors(
    primaryColor: Color(0xFF191970),
    backgroundColor: Color(0xFFF1F4FA),
    labelColor: Color(0xFF4B5563),
    iconColor: Color(0xFF5D6675),
  );

  final AuthActionButtonColors actionButtonColors =
      const AuthActionButtonColors(
        backgroundColor: Color(0xFFF7F9FC),
        foregroundColor: Color(0xFF191970),
        disabledBackgroundColor: Color(0xFFE5E7EB),
        disabledForegroundColor: Color(0xFF9CA3AF),
      );

  final AuthSocialButtonsColors socialButtonsColors =
      const AuthSocialButtonsColors(
        foregroundColor: Color(0xFF191970),
        borderColor: Color(0xFF9CA3AF),
      );
}
