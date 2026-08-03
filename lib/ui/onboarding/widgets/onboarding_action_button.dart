import 'package:flutter/material.dart';

import '../theme/onboarding_colors.dart';

/// Pulsante d'azione principale dell'onboarding.
class OnboardingActionButton extends StatelessWidget {
  const OnboardingActionButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.colors = const OnboardingActionButtonColors(),
  });

  /// Testo mostrato nel pulsante.
  final String label;

  /// Callback invocata alla pressione.
  ///
  /// Se è null, il pulsante viene mostrato come disabilitato.
  final VoidCallback? onPressed;

  /// Palette cromatica del pulsante.
  final OnboardingActionButtonColors colors;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.backgroundColor,
          foregroundColor: colors.foregroundColor,
          disabledBackgroundColor: colors.disabledBackgroundColor,
          disabledForegroundColor: colors.disabledForegroundColor,
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
