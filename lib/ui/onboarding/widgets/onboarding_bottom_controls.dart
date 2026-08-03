import 'package:flutter/material.dart';

import '../theme/onboarding_colors.dart';
import 'onboarding_action_button.dart';
import 'onboarding_dots_indicator.dart';

/// Controlli inferiori della schermata onboarding.
///
/// Coordina il bottone "Indietro", l'indicatore delle pagine
/// e il bottone principale "Avanti" o "Inizia".
class OnboardingBottomControls extends StatelessWidget {
  const OnboardingBottomControls({
    super.key,
    required this.currentIndex,
    required this.itemCount,
    required this.onBack,
    required this.onNext,
    this.actionButtonColors = const OnboardingActionButtonColors(),
    this.dotsColors = const OnboardingDotsIndicatorColors(),
    this.backButtonColor = const Color(0xFF191970),
  });

  /// Indice della pagina attualmente visibile.
  final int currentIndex;

  /// Numero totale delle pagine dell'onboarding.
  final int itemCount;

  /// Callback invocata dal bottone "Indietro".
  final VoidCallback onBack;

  /// Callback invocata dal bottone "Avanti" o "Inizia".
  final VoidCallback onNext;

  /// Palette del bottone principale.
  final OnboardingActionButtonColors actionButtonColors;

  /// Palette dell'indicatore delle pagine.
  final OnboardingDotsIndicatorColors dotsColors;

  /// Colore del bottone testuale "Indietro".
  final Color backButtonColor;

  @override
  Widget build(BuildContext context) {
    final isLastPage = currentIndex == itemCount - 1;

    return SizedBox(
      height: 52,
      child: Stack(
        alignment: Alignment.center,
        children: [
          OnboardingDotsIndicator(
            currentIndex: currentIndex,
            itemCount: itemCount,
            colors: dotsColors,
          ),
          if (currentIndex > 0)
            Align(
              alignment: Alignment.centerLeft,
              child: _OnboardingBackButton(
                onPressed: onBack,
                color: backButtonColor,
              ),
            ),
          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              width: 112,
              child: OnboardingActionButton(
                label: isLastPage ? 'Inizia' : 'Avanti',
                onPressed: onNext,
                colors: actionButtonColors,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingBackButton extends StatelessWidget {
  const _OnboardingBackButton({required this.onPressed, required this.color});

  final VoidCallback onPressed;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.chevron_left_rounded, size: 18),
      label: const Text('Indietro'),
      style: TextButton.styleFrom(
        foregroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        minimumSize: const Size(48, 48),
        tapTargetSize: MaterialTapTargetSize.padded,
      ),
    );
  }
}
