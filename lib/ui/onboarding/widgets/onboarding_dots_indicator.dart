import 'package:flutter/material.dart';

import '../theme/onboarding_colors.dart';

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
