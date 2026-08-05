import 'package:flutter/material.dart';

import '../../core/themes/app_colors.dart';
import '../../core/themes/app_segmented_control_colors.dart';

/// Palette dei campi di testo della feature auth.
class AuthTextFieldColors {
  const AuthTextFieldColors({
    this.primaryColor = AppColors.primary,
    this.backgroundColor = AppColors.fieldBackground,
    this.labelColor = const Color(0xFF4B5563),
    this.iconColor = AppColors.textSecondary,
  });

  final Color primaryColor;
  final Color backgroundColor;
  final Color labelColor;
  final Color iconColor;
}

/// Palette dei bottoni principali della feature auth.
class AuthActionButtonColors {
  const AuthActionButtonColors({
    this.backgroundColor = AppColors.background,
    this.foregroundColor = AppColors.primary,
    this.disabledBackgroundColor = const Color(0xFFE5E7EB),
    this.disabledForegroundColor = const Color(0xFF9CA3AF),
  });

  final Color backgroundColor;
  final Color foregroundColor;
  final Color disabledBackgroundColor;
  final Color disabledForegroundColor;
}

/// Palette dei bottoni social della feature auth.
class AuthSocialButtonsColors {
  const AuthSocialButtonsColors({
    this.foregroundColor = AppColors.primary,
    this.borderColor = const Color(0xFF9CA3AF),
  });

  final Color foregroundColor;
  final Color borderColor;
}

/// Palette della schermata principale di autenticazione.
class AuthChoiceColors {
  const AuthChoiceColors();

  final Color backgroundColor = AppColors.surface;
  final Color primaryColor = AppColors.primary;
  final Color screenTitleColor = AppColors.textPrimary;
  final Color subtitleColor = const Color(0xFF4B5563);
  final Color helperTextColor = AppColors.textMuted;
  final Color dividerColor = const Color(0xFFD1D5DB);
  final Color separatorTextColor = AppColors.textMuted;
  final Color backButtonColor = AppColors.textMuted;

  final AppSegmentedControlColors segmentedControlColors =
      const AppSegmentedControlColors(
        backgroundColor: AppColors.fieldBackground,
        selectedColor: AppColors.surface,
        borderColor: AppColors.borderSoft,
        selectedTextColor: AppColors.primary,
        selectedBadgeTextColor: AppColors.primary,
      );

  final AuthTextFieldColors textFieldColors = const AuthTextFieldColors();

  final AuthActionButtonColors actionButtonColors =
      const AuthActionButtonColors();

  final AuthSocialButtonsColors socialButtonsColors =
      const AuthSocialButtonsColors();
}

/// Palette della schermata di recupero password.
class ResetPasswordColors {
  const ResetPasswordColors();

  final Color backgroundColor = AppColors.surface;
  final Color primaryColor = AppColors.primary;
  final Color descriptionColor = const Color(0xFF4B5563);
  final Color snackBarBackgroundColor = AppColors.primaryDark;
  final Color snackBarTextColor = AppColors.surface;

  final AuthTextFieldColors textFieldColors = const AuthTextFieldColors();

  final AuthActionButtonColors actionButtonColors =
      const AuthActionButtonColors(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.surface,
      );
}
