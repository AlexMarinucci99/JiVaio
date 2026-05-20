import 'package:flutter/material.dart';

class HideOnboardingPreferenceColors {
  const HideOnboardingPreferenceColors({
    this.selectedColor = const Color(0xFF061A3A),
    this.selectedBackgroundColor = const Color(0x14061A3A),
    this.selectedBorderColor = const Color(0x6B061A3A),
    this.unselectedBackgroundColor = const Color(0xFFFAFBFF),
    this.unselectedBorderColor = const Color(0xFFE4E9F2),
    this.unselectedCheckBorderColor = const Color(0xFFC5CCD8),
    this.checkIconColor = Colors.white,
    this.titleColor = const Color(0xFF101828),
    this.subtitleColor = const Color(0xFF667085),
  });

  // Colore principale usato quando il box è selezionato.
  final Color selectedColor;

  // Sfondo del box quando è selezionato.
  final Color selectedBackgroundColor;

  // Bordo del box quando è selezionato.
  final Color selectedBorderColor;

  // Sfondo del box quando non è selezionato.
  final Color unselectedBackgroundColor;

  // Bordo del box quando non è selezionato.
  final Color unselectedBorderColor;

  // Bordo della casellina quando non è selezionata.
  final Color unselectedCheckBorderColor;

  // Colore dell'icona check.
  final Color checkIconColor;

  // Colore del titolo.
  final Color titleColor;

  // Colore del sottotitolo.
  final Color subtitleColor;
}

// Box cliccabile per scegliere se non mostrare più l'onboarding.
class HideOnboardingPreference extends StatelessWidget {
  const HideOnboardingPreference({
    super.key,
    required this.value,
    required this.onChanged,
    this.colors = const HideOnboardingPreferenceColors(),
  });

  // Stato della casellina: false = non selezionata, true = selezionata.
  final bool value;

  // Callback chiamata quando l'utente clicca sul box.
  final VoidCallback onChanged;

  // Palette colori propria del widget.
  final HideOnboardingPreferenceColors colors;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      // Click su tutto il box.
      onTap: onChanged,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),

        // Box esterno.
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
            // Casellina sinistra.
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

              // Icona check dentro la casellina.
              child: value
                  ? Icon(
                      Icons.check_rounded,
                      size: 17,
                      color: colors.checkIconColor,
                    )
                  : null,
            ),

            const SizedBox(width: 14),

            // Testi del box.
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

                  // Sottotitolo.
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