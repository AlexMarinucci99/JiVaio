import 'package:flutter/material.dart';

class OnboardingActionButtonColors {
  const OnboardingActionButtonColors({
    this.backgroundColor = const Color(0xFF191970),
    this.foregroundColor = Colors.white,
    this.disabledBackgroundColor = const Color(0xFFE5E7EB),
    this.disabledForegroundColor = const Color(0xFF9CA3AF),
  });

  // Colore di sfondo del bottone attivo.
  final Color backgroundColor;

  // Colore del testo del bottone attivo.
  final Color foregroundColor;

  // Colore di sfondo quando il bottone è disabilitato.
  final Color disabledBackgroundColor;

  // Colore del testo quando il bottone è disabilitato.
  final Color disabledForegroundColor;
}

class OnboardingActionButton extends StatelessWidget {
  const OnboardingActionButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.height = 52,
    this.colors = const OnboardingActionButtonColors(),
  });

  final String label;
  final VoidCallback? onPressed;
  final double height;

  // Palette colori propria del bottone onboarding.
  final OnboardingActionButtonColors colors;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
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
        child: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}