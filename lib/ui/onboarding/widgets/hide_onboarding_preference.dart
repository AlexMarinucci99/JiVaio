import 'package:flutter/material.dart';

// Box cliccabile per scegliere se non mostrare più l'onboarding.
class HideOnboardingPreference extends StatelessWidget {
  const HideOnboardingPreference({
    super.key,
    required this.value,
    required this.onChanged,
  });

  // Stato della casellina: false = non selezionata, true = selezionata.
  final bool value;

  // Callback chiamata quando l'utente clicca sul box.
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    // Questo colore controlla:
    // - casellina selezionata
    // - bordo del box selezionato
    // - sfondo leggero del box selezionato
    const selectedColor = Color(0xFF061A3A);

    // Colori dello stato non selezionato.
    const unselectedBackgroundColor = Color(0xFFFAFBFF);
    const unselectedBorderColor = Color(0xFFE4E9F2);
    const unselectedCheckBorderColor = Color(0xFFC5CCD8);

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
              ? selectedColor.withValues(alpha: 0.08)
              : unselectedBackgroundColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: value
                ? selectedColor.withValues(alpha: 0.42)
                : unselectedBorderColor,
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
                color: value ? selectedColor : Colors.transparent,
                borderRadius: BorderRadius.circular(7),
                border: Border.all(
                  color: value ? selectedColor : unselectedCheckBorderColor,
                  width: 2,
                ),
              ),
              alignment: Alignment.center,

              // Icona check dentro la casellina.
              child: value
                  ? const Icon(
                      Icons.check_rounded,
                      size: 17,
                      color: Colors.white,
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
                      color: const Color(0xFF101828),
                    ),
                  ),

                  const SizedBox(height: 3),

                  // Sottotitolo.
                  Text(
                    'La salteremo la prossima volta',
                    style: textTheme.bodySmall?.copyWith(
                      fontSize: 12,
                      height: 1.2,
                      color: const Color(0xFF667085),
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
