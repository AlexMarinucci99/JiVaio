import 'package:flutter/material.dart';

import 'app_segmented_nsave.dart';

class AppSegmentedControlColors {
  const AppSegmentedControlColors({
    this.backgroundColor = const Color(0xFFEAF0FA),
    this.selectedColor = const Color(0xFF061A3A),
    this.borderColor = const Color(0xFFDCE5F2),
    this.selectedTextColor = Colors.white,
    this.unselectedTextColor = const Color(0xFF5D6675),
    this.badgeBackgroundColor = const Color(0xFFDCEBFF),
    this.badgeTextColor = const Color(0xFF061A3A),
    this.selectedBadgeBackgroundColor = const Color(0x2EFFFFFF),
    this.selectedBadgeTextColor = Colors.white,
  });

  // Colore del contenitore esterno dello switch.
  final Color backgroundColor;

  // Colore del segmento attivo.
  final Color selectedColor;

  // Colore del bordo esterno.
  final Color borderColor;

  // Colore testo del segmento attivo.
  final Color selectedTextColor;

  // Colore testo dei segmenti non attivi.
  final Color unselectedTextColor;

  // Colore sfondo badge quando il segmento non è selezionato.
  final Color badgeBackgroundColor;

  // Colore testo badge quando il segmento non è selezionato.
  final Color badgeTextColor;

  // Colore sfondo badge quando il segmento è selezionato.
  final Color selectedBadgeBackgroundColor;

  // Colore testo badge quando il segmento è selezionato.
  final Color selectedBadgeTextColor;
}

class AppSegmentedControlItem<T> {
  const AppSegmentedControlItem({
    required this.value,
    required this.label,
    this.badgeLabel,
  });

  // Valore logico dell'opzione.
  final T value;

  // Testo visibile nell'interfaccia.
  final String label;

  // Badge opzionale accanto al testo.
  final String? badgeLabel;
}

class AppSegmentedControl<T> extends StatelessWidget {
  const AppSegmentedControl({
    super.key,
    required this.items,
    required this.selectedValue,
    required this.onChanged,
    this.colors = const AppSegmentedControlColors(),

    // Parametri mantenuti per compatibilità con il codice già scritto.
    // Se vengono passati, sovrascrivono i valori presenti in colors.
    this.backgroundColor,
    this.selectedColor,
    this.borderColor,
    this.selectedTextColor,
    this.unselectedTextColor,
    this.badgeBackgroundColor,
    this.badgeTextColor,
    this.selectedBadgeBackgroundColor,
    this.selectedBadgeTextColor,
  }) : assert(items.length >= 2),
       assert(items.length <= 4);

  // Lista delle opzioni da mostrare.
  final List<AppSegmentedControlItem<T>> items;

  // Valore attualmente selezionato.
  final T selectedValue;

  // Funzione chiamata quando l'utente seleziona una nuova opzione.
  final ValueChanged<T> onChanged;

  // Palette completa del widget.
  // Permette di usare colori diversi in schermate diverse.
  final AppSegmentedControlColors colors;

  // Override opzionale del colore del contenitore esterno.
  final Color? backgroundColor;

  // Override opzionale del colore del segmento attivo.
  final Color? selectedColor;

  // Override opzionale del colore del bordo esterno.
  final Color? borderColor;

  // Override opzionale del colore testo del segmento attivo.
  final Color? selectedTextColor;

  // Override opzionale del colore testo dei segmenti non attivi.
  final Color? unselectedTextColor;

  // Override opzionale del colore sfondo badge non selezionato.
  final Color? badgeBackgroundColor;

  // Override opzionale del colore testo badge non selezionato.
  final Color? badgeTextColor;

  // Override opzionale del colore sfondo badge selezionato.
  final Color? selectedBadgeBackgroundColor;

  // Override opzionale del colore testo badge selezionato.
  final Color? selectedBadgeTextColor;

  @override
  Widget build(BuildContext context) {
    // Colori effettivi usati dal widget.
    // Prima controllano gli override singoli, poi usano la palette colors.
    final effectiveBackgroundColor = backgroundColor ?? colors.backgroundColor;
    final effectiveSelectedColor = selectedColor ?? colors.selectedColor;
    final effectiveBorderColor = borderColor ?? colors.borderColor;
    final effectiveSelectedTextColor =
        selectedTextColor ?? colors.selectedTextColor;
    final effectiveUnselectedTextColor =
        unselectedTextColor ?? colors.unselectedTextColor;
    final effectiveBadgeBackgroundColor =
        badgeBackgroundColor ?? colors.badgeBackgroundColor;
    final effectiveBadgeTextColor = badgeTextColor ?? colors.badgeTextColor;
    final effectiveSelectedBadgeBackgroundColor =
        selectedBadgeBackgroundColor ?? colors.selectedBadgeBackgroundColor;
    final effectiveSelectedBadgeTextColor =
        selectedBadgeTextColor ?? colors.selectedBadgeTextColor;

    return Container(
      // Box esterno dello switch.
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: effectiveBorderColor),
      ),

      // Riga orizzontale dei segmenti.
      child: Row(
        children: items
            .map((item) {
              final isSelected = item.value == selectedValue;
              final hasBadge =
                  item.badgeLabel != null && item.badgeLabel!.isNotEmpty;

              return Expanded(
                child: TextButton(
                  onPressed: () {
                    if (isSelected) {
                      return;
                    }

                    onChanged(item.value);
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: isSelected
                        ? effectiveSelectedColor
                        : Colors.transparent,
                    foregroundColor: isSelected
                        ? effectiveSelectedTextColor
                        : effectiveUnselectedTextColor,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(11),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        item.label,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: isSelected
                                  ? effectiveSelectedTextColor
                                  : effectiveUnselectedTextColor,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                      ),

                      if (hasBadge) ...[
                        const SizedBox(width: 8),
                        AppSegmentedNSave(
                          label: item.badgeLabel!,
                          backgroundColor: isSelected
                              ? effectiveSelectedBadgeBackgroundColor
                              : effectiveBadgeBackgroundColor,
                          textColor: isSelected
                              ? effectiveSelectedBadgeTextColor
                              : effectiveBadgeTextColor,
                        ),
                      ],
                    ],
                  ),
                ),
              );
            })
            .toList(growable: false),
      ),
    );
  }
}
