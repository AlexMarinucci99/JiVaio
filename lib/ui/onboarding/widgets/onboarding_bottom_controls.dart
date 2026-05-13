import 'package:flutter/material.dart';

import '../../core/widgets/primary_button.dart';
import 'onboarding_dots_indicator.dart';

// Widget inferiore dell'onboarding.
// Gestisce solo: bottone indietro, dots centrali e bottone avanti/inizia.
class OnboardingBottomControls extends StatelessWidget {
  const OnboardingBottomControls({
    super.key,
    required this.currentIndex,
    required this.itemCount,
    required this.isLastPage,
    required this.onBack,
    required this.onNext,
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
            ),
          ),

          // Bottone/testo "Indietro", visibile dalla seconda pagina.
          if (currentIndex > 0)
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: onBack,
                icon: const Icon(Icons.chevron_left_rounded, size: 18),
                label: const Text('Indietro'),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(0, 44),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ),

          // Bottone inferiore destro.
          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              width: 112,
              child: PrimaryButton(
                label: isLastPage ? 'Inizia' : 'Avanti',
                onPressed: onNext,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
