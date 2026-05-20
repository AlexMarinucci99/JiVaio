import 'package:flutter/material.dart';

import 'onboarding_action_button.dart';
import 'onboarding_dots_indicator.dart';

// Widget inferiore dell'onboarding.
// Coordina tre elementi: bottone indietro, dots centrali e bottone avanti/inizia.
class OnboardingBottomControls extends StatelessWidget {
  const OnboardingBottomControls({
    super.key,
    required this.currentIndex,
    required this.itemCount,
    required this.isLastPage,
    required this.onBack,
    required this.onNext,
    this.actionButtonColors = const OnboardingActionButtonColors(),
    this.dotsColors = const OnboardingDotsIndicatorColors(),
    this.backButtonColor = const Color(0xFF191970),
  });

  // Pagina attuale dell'onboarding.
  final int currentIndex;

  // Numero totale di pagine onboarding.
  final int itemCount;

  // true se siamo nell'ultima pagina.
  final bool isLastPage;

  // Azione bottone "Indietro".
  final VoidCallback onBack;

  // Azione bottone "Avanti" / "Inizia".
  final VoidCallback onNext;

  // Colori del bottone principale dell'onboarding.
  final OnboardingActionButtonColors actionButtonColors;

  // Colori dei pallini centrali.
  final OnboardingDotsIndicatorColors dotsColors;

  // Colore del bottone testuale "Indietro".
  final Color backButtonColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Dots centrati.
          Center(
            child: OnboardingDotsIndicator(
              currentIndex: currentIndex,
              itemCount: itemCount,
              colors: dotsColors,
            ),
          ),

          // Bottone "Indietro", visibile dalla seconda pagina.
          if (currentIndex > 0)
            Align(
              alignment: Alignment.centerLeft,
              child: _OnboardingBackButton(
                onPressed: onBack,
                color: backButtonColor,
              ),
            ),

          // Bottone inferiore destro.
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

// Widget privato per il bottone "Indietro".
// Rimane nello stesso file perché per ora non viene riutilizzato altrove.
class _OnboardingBackButton extends StatelessWidget {
  const _OnboardingBackButton({
    required this.onPressed,
    required this.color,
  });

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
        padding: EdgeInsets.zero,
        minimumSize: const Size(0, 44),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}