import 'package:flutter/material.dart';

import '../widgets/hide_onboarding_preference.dart';
import '../widgets/onboarding_action_button.dart';
import '../widgets/onboarding_dots_indicator.dart';
import '../widgets/onboarding_slide_card.dart';

/// Palette complessiva della schermata di onboarding.
///
/// Aggrega i colori dei componenti interni, mantenendo la configurazione
/// grafica separata dalla struttura della schermata.
class OnboardingColors {
  const OnboardingColors({
    this.backgroundColor = const Color(0xFFF7F9FC),
    this.skipButtonColor = const Color(0xFF191970),
    this.backButtonColor = const Color(0xFF191970),
    this.slideCardColors = const OnboardingSlideCardColors(
      imageCardBackgroundColor: Colors.white,
      iconBackgroundColor: Color(0xE0FFFFFF),
      accentColor: Color(0xFF191970),
      titleColor: Color(0xFF101828),
      descriptionColor: Color(0xFF667085),
    ),
    this.actionButtonColors = const OnboardingActionButtonColors(
      backgroundColor: Color(0xFF191970),
      foregroundColor: Colors.white,
      disabledBackgroundColor: Color(0xFFE5E7EB),
      disabledForegroundColor: Color(0xFF9CA3AF),
    ),
    this.dotsColors = const OnboardingDotsIndicatorColors(
      activeColor: Color(0xFF191970),
      inactiveColor: Color(0xFFE1E7F0),
    ),
    this.hidePreferenceColors = const HideOnboardingPreferenceColors(
      selectedColor: Color(0xFF191970),
      selectedBackgroundColor: Color(0x14061A3A),
      selectedBorderColor: Color(0x6B061A3A),
      unselectedBackgroundColor: Color(0xFFFAFBFF),
      unselectedBorderColor: Color(0xFFE4E9F2),
      unselectedCheckBorderColor: Color(0xFFC5CCD8),
      checkIconColor: Colors.white,
      titleColor: Color(0xFF101828),
      subtitleColor: Color(0xFF667085),
    ),
  });

  /// Sfondo generale della schermata onboarding.
  final Color backgroundColor;

  /// Colore del bottone testuale "Salta".
  final Color skipButtonColor;

  /// Colore del bottone testuale "Indietro".
  final Color backButtonColor;

  /// Colori della card della singola slide.
  final OnboardingSlideCardColors slideCardColors;

  /// Colori del bottone "Avanti" o "Inizia".
  final OnboardingActionButtonColors actionButtonColors;

  /// Colori dei dots centrali.
  final OnboardingDotsIndicatorColors dotsColors;

  /// Colori del box "Non mostrarla più".
  final HideOnboardingPreferenceColors hidePreferenceColors;
}
