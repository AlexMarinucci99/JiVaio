import 'package:flutter/material.dart';

import '../../core/themes/app_colors.dart';

/// Palette della card che mostra una slide dell'onboarding.
class OnboardingSlideCardColors {
  const OnboardingSlideCardColors({
    this.imageCardBackgroundColor = AppColors.surface,
    this.iconBackgroundColor = const Color(0xE0FFFFFF),
    this.titleColor = const Color(0xFF101828),
    this.descriptionColor = const Color(0xFF667085),
  });

  final Color imageCardBackgroundColor;
  final Color iconBackgroundColor;
  final Color titleColor;
  final Color descriptionColor;
}

/// Palette del pulsante principale dell'onboarding.
class OnboardingActionButtonColors {
  const OnboardingActionButtonColors({
    this.backgroundColor = AppColors.primary,
    this.foregroundColor = AppColors.surface,
    this.disabledBackgroundColor = const Color(0xFFE5E7EB),
    this.disabledForegroundColor = const Color(0xFF9CA3AF),
  });

  final Color backgroundColor;
  final Color foregroundColor;
  final Color disabledBackgroundColor;
  final Color disabledForegroundColor;
}

/// Palette dell'indicatore delle pagine.
class OnboardingDotsIndicatorColors {
  const OnboardingDotsIndicatorColors({
    this.activeColor = AppColors.primary,
    this.inactiveColor = AppColors.borderSoft,
  });

  final Color activeColor;
  final Color inactiveColor;
}

/// Palette della preferenza per nascondere l'onboarding.
class HideOnboardingPreferenceColors {
  const HideOnboardingPreferenceColors({
    this.selectedColor = AppColors.primary,
    this.selectedBackgroundColor = const Color(0x14061A3A),
    this.selectedBorderColor = const Color(0x6B061A3A),
    this.unselectedBackgroundColor = const Color(0xFFFAFBFF),
    this.unselectedBorderColor = const Color(0xFFE4E9F2),
    this.unselectedCheckBorderColor = const Color(0xFFC5CCD8),
    this.checkIconColor = AppColors.surface,
    this.titleColor = const Color(0xFF101828),
    this.subtitleColor = const Color(0xFF667085),
  });

  final Color selectedColor;
  final Color selectedBackgroundColor;
  final Color selectedBorderColor;
  final Color unselectedBackgroundColor;
  final Color unselectedBorderColor;
  final Color unselectedCheckBorderColor;
  final Color checkIconColor;
  final Color titleColor;
  final Color subtitleColor;
}

/// Palette complessiva della schermata onboarding.
class OnboardingColors {
  const OnboardingColors({
    this.backgroundColor = AppColors.background,
    this.skipButtonColor = AppColors.primary,
    this.backButtonColor = AppColors.primary,
    this.slideCardColors = const OnboardingSlideCardColors(),
    this.actionButtonColors = const OnboardingActionButtonColors(),
    this.dotsColors = const OnboardingDotsIndicatorColors(),
    this.hidePreferenceColors = const HideOnboardingPreferenceColors(),
  });

  final Color backgroundColor;
  final Color skipButtonColor;
  final Color backButtonColor;
  final OnboardingSlideCardColors slideCardColors;
  final OnboardingActionButtonColors actionButtonColors;
  final OnboardingDotsIndicatorColors dotsColors;
  final HideOnboardingPreferenceColors hidePreferenceColors;
}
