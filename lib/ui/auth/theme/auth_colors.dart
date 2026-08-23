import 'package:flutter/material.dart';

import '../../core/themes/app_colors.dart';
import '../../core/themes/app_segmented_control_colors.dart';

/// Raccoglie i colori condivisi dalla feature auth.
abstract final class AuthColors {
  static const Color backgroundColor = AppColors.surface;
  static const Color primaryColor = AppColors.primary;
  static const Color screenTitleColor = AppColors.textPrimary;
  static const Color secondaryTextColor = Color(0xFF4B5563);
  static const Color mutedTextColor = AppColors.textMuted;
  static const Color dividerColor = Color(0xFFD1D5DB);

  static const Color textFieldBackgroundColor = AppColors.fieldBackground;
  static const Color textFieldIconColor = AppColors.textSecondary;

  static const Color actionButtonBackgroundColor = AppColors.background;
  static const Color actionButtonForegroundColor = AppColors.primary;
  static const Color disabledButtonBackgroundColor = Color(0xFFE5E7EB);
  static const Color disabledButtonForegroundColor = Color(0xFF9CA3AF);

  static const Color socialButtonForegroundColor = AppColors.primary;
  static const Color socialButtonBorderColor = Color(0xFF9CA3AF);

  static const Color snackBarBackgroundColor = AppColors.primaryDark;
  static const Color snackBarTextColor = AppColors.surface;

  static const AppSegmentedControlColors segmentedControlColors =
      AppSegmentedControlColors(
        backgroundColor: AppColors.fieldBackground,
        selectedColor: AppColors.surface,
        borderColor: AppColors.borderSoft,
        selectedTextColor: AppColors.primary,
        selectedBadgeTextColor: AppColors.primary,
      );
}
