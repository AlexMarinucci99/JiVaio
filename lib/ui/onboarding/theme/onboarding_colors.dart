import 'package:flutter/material.dart';

import '../../core/themes/app_colors.dart';

/// Palette centralizzata dell'onboarding.
abstract final class OnboardingColors {
  static const background = AppColors.background;
  static const primary = AppColors.primary;
  static const surface = AppColors.surface;

  static const title = Color(0xFF101828);
  static const description = Color(0xFF667085);

  static const inactiveDot = AppColors.borderSoft;

  static const preferenceSelectedBorder = Color(0x6B061A3A);
  static const preferenceUnselectedBorder = Color(0xFFE4E9F2);
  static const preferenceUnselectedCheckBorder = Color(0xFFC5CCD8);
}
