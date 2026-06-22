import 'package:flutter/material.dart';

/// Palette del box per nascondere l'onboarding nelle aperture successive.
class HideOnboardingPreferenceColors {
  const HideOnboardingPreferenceColors({
    //Da modificare in futuro-Master
    this.selectedColor = const Color.from(
      alpha: 0.075,
      red: 0.8,
      green: 0.533,
      blue: 0.039,
    ),
    this.selectedBackgroundColor = const Color(0x14061A3A),
    this.selectedBorderColor = const Color(0x6B061A3A),
    this.unselectedBackgroundColor = const Color(0xFFFAFBFF),
    this.unselectedBorderColor = const Color(0xFFE4E9F2),
    this.unselectedCheckBorderColor = const Color(0xFFC5CCD8),
    this.checkIconColor = Colors.white,
    //Da modificare in futuro-Master
    this.titleColor = const Color.fromARGB(255, 177, 149, 26),
    this.subtitleColor = const Color(0xFF667085),
  });

  final Color selectedColor;
  final Color selectedBackgroundColor;
  final Color selectedBorderColor;
  final Color unselectedBackgroundColor;
  final Color unselectedBorderColor;
  final Color unselectedCheckBorderColor;
  final Color checkIconColor;
  final Color titleColor;
  final Color subtitleColor;
}

/// Box cliccabile per scegliere se non mostrare più l'onboarding.
class HideOnboardingPreference extends StatelessWidget {
  const HideOnboardingPreference({
    super.key,
    required this.value,
    required this.onChanged,
    this.colors = const HideOnboardingPreferenceColors(),
  });

  /// Indica se la preferenza è selezionata.
  final bool value;

  /// Callback invocata quando l'utente seleziona il box.
  final VoidCallback onChanged;

  /// Palette colori propria del widget.
  final HideOnboardingPreferenceColors colors;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: onChanged,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),

        decoration: BoxDecoration(
          color: value
              ? colors.selectedBackgroundColor
              : colors.unselectedBackgroundColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: value
                ? colors.selectedBorderColor
                : colors.unselectedBorderColor,
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
                color: value ? colors.selectedColor : Colors.transparent,
                borderRadius: BorderRadius.circular(7),
                border: Border.all(
                  color: value
                      ? colors.selectedColor
                      : colors.unselectedCheckBorderColor,
                  width: 2,
                ),
              ),
              alignment: Alignment.center,

              child: value
                  ? Icon(
                      Icons.check_rounded,
                      size: 17,
                      color: colors.checkIconColor,
                    )
                  : null,
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Titolo.
                  Text(
                    'Non mostrarla più',
                    style: textTheme.titleMedium?.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: colors.titleColor,
                    ),
                  ),

                  const SizedBox(height: 3),
                  Text(
                    'La salteremo la prossima volta',
                    style: textTheme.bodySmall?.copyWith(
                      fontSize: 12,
                      height: 1.2,
                      color: colors.subtitleColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
