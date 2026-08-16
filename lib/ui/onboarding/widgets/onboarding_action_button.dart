import 'package:flutter/material.dart';

import '../theme/onboarding_colors.dart';

/// Pulsante d'azione principale dell'onboarding.
class OnboardingActionButton extends StatelessWidget {
  const OnboardingActionButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  /// Testo mostrato nel pulsante.
  final String label;

  /// Callback invocata alla pressione.
  ///
  /// Se è null, il pulsante viene mostrato come disabilitato.
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: OnboardingColors.primary,
          foregroundColor: OnboardingColors.surface,
          disabledBackgroundColor: OnboardingColors.actionDisabledBackground,
          disabledForegroundColor: OnboardingColors.actionDisabledForeground,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
      ),
    );
  }
}
