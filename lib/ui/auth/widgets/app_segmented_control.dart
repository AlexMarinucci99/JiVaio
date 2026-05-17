import 'package:flutter/material.dart';

class AppSegmentedControlItem<T> {
  const AppSegmentedControlItem({required this.value, required this.label});

  // Valore logico dell'opzione.
  // Esempio: LinesScope.all, LinesScope.saved, oppure una String.
  final T value;

  // Testo visibile nell'interfaccia.
  // Esempio: "Tutte", "Salvate".
  final String label;
}

class AppSegmentedControl<T> extends StatelessWidget {
  const AppSegmentedControl({
    super.key,
    required this.items,
    required this.selectedValue,
    required this.onChanged,
    this.backgroundColor = const Color(0xFFEAF0FA),
    this.selectedColor = const Color(0xFF061A3A),
    this.borderColor = const Color(0xFFDCE5F2),
    this.selectedTextColor = Colors.white,
    this.unselectedTextColor = const Color(0xFF5D6675),
  }) : assert(items.length >= 2),
       assert(items.length <= 4);

  // Lista delle opzioni da mostrare.
  final List<AppSegmentedControlItem<T>> items;

  // Valore attualmente selezionato.
  final T selectedValue;

  // Funzione chiamata quando l'utente seleziona una nuova opzione.
  final ValueChanged<T> onChanged;

  // Colore del contenitore esterno.
  final Color backgroundColor;

  // Colore del segmento attivo.
  final Color selectedColor;

  // Colore del bordo esterno.
  final Color borderColor;

  // Colore testo del segmento attivo.
  final Color selectedTextColor;

  // Colore testo dei segmenti non attivi.
  final Color unselectedTextColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      // Box esterno dello switch.
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),

      // Riga orizzontale dei segmenti.
      child: Row(
        children: items
            .map((item) {
              final isSelected = item.value == selectedValue;

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
                        ? selectedColor
                        : Colors.transparent,
                    foregroundColor: isSelected
                        ? selectedTextColor
                        : unselectedTextColor,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(11),
                    ),
                  ),
                  child: Text(
                    item.label,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: isSelected
                          ? selectedTextColor
                          : unselectedTextColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              );
            })
            .toList(growable: false),
      ),
    );
  }
}
