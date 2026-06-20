import 'package:flutter/material.dart';

/// Palette dell'indicatore delle pagine dell'oboarding.
class OnboardingDotsIndicatorColors {
  const OnboardingDotsIndicatorColors({
    this.activeColor = const Color(0x14061A3A),
    this.inactiveColor = const Color(0xFFE1E7F0),
  });

  /// Colore del pallino della pagina attiva.
  final Color activeColor;

  /// Colore dei pallini delle pagine non attive.
  final Color inactiveColor;
}

/// Indicatore delle pagine dell'onboarding.
class OnboardingDotsIndicator extends StatelessWidget {
  const OnboardingDotsIndicator({
    super.key,
    required this.currentIndex,
    required this.itemCount,
    this.colors = const OnboardingDotsIndicatorColors(),
  });

  /// Indice della pagina attualmente visibile.
  final int currentIndex;

  /// Numero totale di pagine dell'onboarding.
  final int itemCount;

  /// Palette colori propria dei dots.
  final OnboardingDotsIndicatorColors colors;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(itemCount, (index) {
        final isActive = index == currentIndex;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          margin: const EdgeInsets.symmetric(horizontal: 5),
          width: isActive ? 26 : 9,
          height: 9,
          decoration: BoxDecoration(
            color: isActive ? colors.activeColor : colors.inactiveColor,
            borderRadius: BorderRadius.circular(99),
          ),
        );
      }),
    );
  }
}
