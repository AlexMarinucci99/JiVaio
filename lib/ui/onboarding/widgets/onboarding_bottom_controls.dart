import 'package:flutter/material.dart';

import '../theme/onboarding_colors.dart';
import 'onboarding_action_button.dart';
import 'onboarding_dots_indicator.dart';

/// Controlli inferiori della schermata onboarding.
///
/// Coordina il bottone "Indietro", l'indicatore delle pagine
/// e il bottone principale "Avanti/Inizia".
class OnboardingBottomControls extends StatelessWidget {
  const OnboardingBottomControls({
    super.key,
    required this.currentIndex,
    required this.itemCount,
    required this.onBack,
    required this.onNext,
  });

  final int currentIndex;
  final int itemCount;
  final VoidCallback onBack;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: Stack(
        alignment: Alignment.center,
        children: [
          OnboardingDotsIndicator(
            currentIndex: currentIndex,
            itemCount: itemCount,
          ),
          if (currentIndex > 0)
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: onBack,
                icon: const Icon(Icons.chevron_left_rounded, size: 18),
                label: const Text('Indietro'),
                style: TextButton.styleFrom(
                  foregroundColor: OnboardingColors.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  minimumSize: const Size(48, 48),
                  tapTargetSize: MaterialTapTargetSize.padded,
                ),
              ),
            ),
          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              width: 112,
              child: OnboardingActionButton(
                label: currentIndex == itemCount - 1 ? 'Inizia' : 'Avanti',
                onPressed: onNext,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
