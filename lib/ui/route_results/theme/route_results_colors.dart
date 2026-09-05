import 'package:flutter/material.dart';

import '../../core/themes/app_colors.dart';

/// Palette grafica della schermata dei risultati del percorso.

class RouteResultsColors {
  const RouteResultsColors._();

  static const Color backgroundColor = AppColors.background;
  static const Color surfaceColor = AppColors.surface;
  static const Color textPrimaryColor = Color.fromARGB(255, 132, 136, 145);
  static const Color textSecondaryColor = Color.fromARGB(255, 181, 183, 187);
  static const Color borderColor = AppColors.border;

  static const Color headerGradientStartColor = Color(0xFF17226B);
  static const Color headerGradientEndColor = AppColors.primary;
  static const Color headerTextColor = Colors.white;
  static const Color headerMutedTextColor = Color(0xFFBEC7E8);

  static const Color summaryCardBackgroundColor = Color(0x1FFFFFFF);
  static const Color summaryCardBorderColor = Color(0x33FFFFFF);
  static const Color summaryDividerColor = Color(0x33FFFFFF);

  static const Color accentColor = Color(0xFF2D7FF9);
  static const Color accentSoftColor = Color(0xFFEAF2FF);
  static const Color accentBorderColor = Color(0xFFD6E4FC);
}
