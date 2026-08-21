import 'package:flutter/material.dart';

import '../../core/themes/app_colors.dart';

/// Palette centralizzata dell'onboarding.
abstract final class OnboardingColors {
  static const background = AppColors.background;
  static const primary = AppColors.primary;
  static const surface = AppColors.surface;

  static const slideIconBackground = Color(0xE0FFFFFF);
  static const title = Color(0xFF101828);
  static const description = Color(0xFF667085);

  static const actionDisabledBackground = Color(0xFFE5E7EB);
  static const actionDisabledForeground = Color(0xFF9CA3AF);
  static const inactiveDot = AppColors.borderSoft;

  static const preferenceSelectedBorder = Color(0x6B061A3A);
  static const preferenceUnselectedBorder = Color(0xFFE4E9F2);
  static const preferenceUnselectedCheckBorder = Color(0xFFC5CCD8);
}
