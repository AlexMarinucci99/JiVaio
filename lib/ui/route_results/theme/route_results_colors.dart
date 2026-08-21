import 'package:flutter/material.dart';

import '../../core/themes/app_colors.dart';

/// Palette grafica della schermata dei risultati del percorso.

class RouteResultsColors {
  const RouteResultsColors({
    this.backgroundColor = AppColors.background,
    this.surfaceColor = AppColors.surface,
    this.textPrimaryColor = AppColors.textPrimary,
    this.textSecondaryColor = AppColors.textSecondary,
    this.borderColor = AppColors.border,
    this.headerGradientStartColor = const Color(0xFF17226B),
    this.headerGradientEndColor = AppColors.primary,
    this.headerTextColor = Colors.white,
    this.headerMutedTextColor = const Color(0xFFBEC7E8),
    this.summaryCardBackgroundColor = const Color(0x1FFFFFFF),
    this.summaryCardBorderColor = const Color(0x33FFFFFF),
    this.summaryDividerColor = const Color(0x33FFFFFF),
    this.accentColor = const Color(0xFF2D7FF9),
    this.accentSoftColor = const Color(0xFFEAF2FF),
    this.accentBorderColor = const Color(0xFFD6E4FC),
  });

  final Color backgroundColor;
  final Color surfaceColor;
  final Color textPrimaryColor;
  final Color textSecondaryColor;
  final Color borderColor;

  final Color headerGradientStartColor;
  final Color headerGradientEndColor;
  final Color headerTextColor;
  final Color headerMutedTextColor;

  final Color summaryCardBackgroundColor;
  final Color summaryCardBorderColor;
  final Color summaryDividerColor;

  final Color accentColor;
  final Color accentSoftColor;
  final Color accentBorderColor;
}
