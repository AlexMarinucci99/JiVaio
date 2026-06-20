import 'package:flutter/material.dart';

import 'app_segmented_nsave.dart';
import '../themes/app_segmented_control_colors.dart';

export '../themes/app_segmented_control_colors.dart';

/// Rappresenta una voce selezionabile di [AppSegmentedControl].
class AppSegmentedControlItem<T> {
  const AppSegmentedControlItem({
    required this.value,
    required this.label,
    this.badgeLabel,
  });

  /// Valore associato all'opzione.
  final T value;

  /// Testo mostrato nel segmento.
  final String label;

  /// Testo opzionale mostrato nel badge del segmento.
  final String? badgeLabel;
}

/// Controllo segmentato riutilizzabile dell'app.
///
/// Supporta da due a quattro opzioni e può essere personalizzato
/// tramite [colors] oppure tramite override puntuali dei colori.
class AppSegmentedControl<T> extends StatelessWidget {
  const AppSegmentedControl({
    super.key,
    required this.items,
    required this.selectedValue,
    required this.onChanged,
    this.colors = AppSegmentedControlColors.primary,
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

  /// Opzioni mostrate nel controllo.
  final List<AppSegmentedControlItem<T>> items;

  /// Valore attualmente selezionato.
  final T selectedValue;

  /// Callback invocata quando l'utente seleziona una nuova opzione.
  final ValueChanged<T> onChanged;

  /// Palette cromatica predefinita del controllo.
  final AppSegmentedControlColors colors;

  /// Override opzionale del colore del contenitore esterno.
  final Color? backgroundColor;

  /// Override opzionale del colore del segmento selezionato.
  final Color? selectedColor;

  /// Override opzionale del colore del bordo esterno.
  final Color? borderColor;

  /// Override opzionale del colore del testo selezionato.
  final Color? selectedTextColor;

  /// Override opzionale del colore del testo non selezionato.
  final Color? unselectedTextColor;

  /// Override opzionale dello sfondo del badge non selezionato.
  final Color? badgeBackgroundColor;

  /// Override opzionale del testo del badge non selezionato.
  final Color? badgeTextColor;

  /// Override opzionale dello sfondo del badge selezionato.
  final Color? selectedBadgeBackgroundColor;

  /// Override opzionale del testo del badge selezionato.
  final Color? selectedBadgeTextColor;

  @override
  Widget build(BuildContext context) {
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
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: effectiveBorderColor),
      ),
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
                        : const Color(0x00000000),
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
