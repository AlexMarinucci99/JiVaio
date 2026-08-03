import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Definisce le palette cromatiche del segmented control condiviso.
class AppSegmentedControlColors {
  const AppSegmentedControlColors({
    this.backgroundColor = AppColors.surfaceMuted,
    this.selectedColor = AppColors.primary,
    this.borderColor = AppColors.border,
    this.selectedTextColor = AppColors.surface,
    this.unselectedTextColor = AppColors.textSecondary,
    this.badgeBackgroundColor = const Color(0xFFDCEBFF),
    this.badgeTextColor = AppColors.primary,
    this.selectedBadgeBackgroundColor = const Color(0x2EFFFFFF),
    this.selectedBadgeTextColor = AppColors.surface,
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
}
