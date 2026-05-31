import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppSegmentedControlColors {
  const AppSegmentedControlColors({
    required this.backgroundColor,
    required this.selectedColor,
    required this.borderColor,
    required this.selectedTextColor,
    required this.unselectedTextColor,
    required this.badgeBackgroundColor,
    required this.badgeTextColor,
    required this.selectedBadgeBackgroundColor,
    required this.selectedBadgeTextColor,
  });

  final Color backgroundColor;
  final Color selectedColor;
  final Color borderColor;
  final Color selectedTextColor;
  final Color unselectedTextColor;
  final Color badgeBackgroundColor;
  final Color badgeTextColor;
  final Color selectedBadgeBackgroundColor;
  final Color selectedBadgeTextColor;

  // Palette standard del segmented control.
  // Usala nelle schermate normali, come LinesScreen.
  static const AppSegmentedControlColors primary =
      AppSegmentedControlColors(
    backgroundColor: AppColors.surfaceMuted,
    selectedColor: Color(0xFF191970),
    borderColor: AppColors.border,
    selectedTextColor: AppColors.surface,
    unselectedTextColor: AppColors.textSecondary,
    badgeBackgroundColor: AppColors.badgeBackground,
    badgeTextColor: AppColors.primary,
    selectedBadgeBackgroundColor: AppColors.selectedBadgeBackground,
    selectedBadgeTextColor: AppColors.surface,
  );

  // Palette alternativa per schermate auth
  // il segmento selezionato bianco su sfondo chiaro.
  static const AppSegmentedControlColors auth =
      AppSegmentedControlColors(
    backgroundColor: AppColors.fieldBackground,
    selectedColor: AppColors.surface,
    borderColor: AppColors.borderSoft,
    selectedTextColor: AppColors.primary,
    unselectedTextColor: AppColors.textSecondary,
    badgeBackgroundColor: AppColors.badgeBackground,
    badgeTextColor: AppColors.primary,
    selectedBadgeBackgroundColor: AppColors.selectedBadgeBackground,
    selectedBadgeTextColor: AppColors.primary,
  );
}