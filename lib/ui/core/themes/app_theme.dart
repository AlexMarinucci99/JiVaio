import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Temi globali dell'app.
class AppTheme {
  const AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
      scaffoldBackgroundColor: AppColors.background,
    );
  }
}
