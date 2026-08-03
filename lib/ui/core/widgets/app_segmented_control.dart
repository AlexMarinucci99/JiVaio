import 'package:flutter/material.dart';

import '../themes/app_segmented_control_colors.dart';
import 'app_segmented_badge.dart';

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
/// tramite una palette [AppSegmentedControlColors].
class AppSegmentedControl<T> extends StatelessWidget {
  const AppSegmentedControl({
    super.key,
    required this.items,
    required this.selectedValue,
    required this.onChanged,
    this.colors = const AppSegmentedControlColors(),
  }) : assert(items.length >= 2 && items.length <= 4);

  /// Opzioni mostrate nel controllo.
  final List<AppSegmentedControlItem<T>> items;

  /// Valore attualmente selezionato.
  final T selectedValue;

  /// Callback invocata quando l'utente seleziona una nuova opzione.
  final ValueChanged<T> onChanged;

  /// Palette cromatica del controllo.
  final AppSegmentedControlColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: colors.backgroundColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.borderColor),
      ),
      child: Row(
        children: items
            .map((item) {
              final isSelected = item.value == selectedValue;
              final textColor = isSelected
                  ? colors.selectedTextColor
                  : colors.unselectedTextColor;
              final badgeLabel = item.badgeLabel;

              return Expanded(
                child: TextButton(
                  onPressed: () {
                    if (!isSelected) {
                      onChanged(item.value);
                    }
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: isSelected
                        ? colors.selectedColor
                        : Colors.transparent,
                    foregroundColor: textColor,
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
                              color: textColor,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      if (badgeLabel != null && badgeLabel.isNotEmpty) ...[
                        const SizedBox(width: 8),
                        AppSegmentedBadge(
                          label: badgeLabel,
                          backgroundColor: isSelected
                              ? colors.selectedBadgeBackgroundColor
                              : colors.badgeBackgroundColor,
                          textColor: isSelected
                              ? colors.selectedBadgeTextColor
                              : colors.badgeTextColor,
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
