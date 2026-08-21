import 'package:flutter/material.dart';

import '../theme/onboarding_colors.dart';

/// Box cliccabile per scegliere se non mostrare più l'onboarding.
class HideOnboardingPreference extends StatelessWidget {
  const HideOnboardingPreference({
    super.key,
    required this.value,
    required this.onToggle,
  });

  /// Indica se la preferenza è selezionata.
  final bool value;

  /// Callback invocata per alternare la preferenza.
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Semantics(
      container: true,
      checked: value,
      child: InkWell(
        onTap: onToggle,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: value
                  ? OnboardingColors.preferenceSelectedBorder
                  : OnboardingColors.preferenceUnselectedBorder,
              width: 1.4,
            ),
          ),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOutCubic,
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: value ? OnboardingColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(7),
                  border: Border.all(
                    color: value
                        ? OnboardingColors.primary
                        : OnboardingColors.preferenceUnselectedCheckBorder,
                    width: 2,
                  ),
                ),
                alignment: Alignment.center,
                child: value
                    ? Icon(
                        Icons.check_rounded,
                        size: 17,
                        color: OnboardingColors.surface,
                      )
                    : null,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Non mostrarla più',
                      style: textTheme.titleMedium?.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: OnboardingColors.title,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'La salteremo la prossima volta',
                      style: textTheme.bodySmall?.copyWith(
                        fontSize: 12,
                        height: 1.2,
                        color: OnboardingColors.description,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
