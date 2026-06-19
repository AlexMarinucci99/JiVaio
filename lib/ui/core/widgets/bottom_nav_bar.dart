import 'dart:ui';

import 'package:flutter/material.dart';

/// Definisce la palette cromatica della barra di navigazione inferiore.
class BottomNavBarColors {
  const BottomNavBarColors({
    this.backgroundColor = const Color(0xCCFFFFFF),
    this.borderColor = const Color(0x80FFFFFF),
    this.shadowColor = const Color(0x22000000),
    this.selectedColor = const Color(0xFF102A6B),
    this.unselectedColor = const Color(0xFF7D8794),
    this.selectedBackgroundColor = const Color(0xFFEAF2FF),
    this.selectedGlowColor = const Color(0x33102A6B),
    this.splashColor = const Color(0x14102A6B),
    this.highlightColor = const Color(0x0A102A6B),
  });

  /// Colore dello sfondo con effetto glass.
  final Color backgroundColor;

  /// Colore del bordo esterno.
  final Color borderColor;

  /// Colore dell'ombra esterna.
  final Color shadowColor;

  /// Colore di icona e testo del tab selezionato.
  final Color selectedColor;

  /// Colore di icona e testo dei tab non selezionati.
  final Color unselectedColor;

  /// Colore dello sfondo dell'indicatore attivo.
  final Color selectedBackgroundColor;

  /// Colore del bagliore associato all'indicatore attivo.
  final Color selectedGlowColor;

  /// Colore dell'effetto tap.
  final Color splashColor;

  /// Colore dell'effetto pressione.
  final Color highlightColor;
}

/// Mostra la barra di navigazione inferiore condivisa dell'app.
///
/// Il widget riceve l'indice selezionato dalla schermata padre e comunica
/// i cambi di tab tramite [onItemSelected].
class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    this.colors = const BottomNavBarColors(),
  });

  /// Indice del tab attualmente selezionato.
  final int selectedIndex;

  /// Callback invocata quando l'utente seleziona un tab.
  final ValueChanged<int> onItemSelected;

  /// Palette cromatica usata dalla barra.
  final BottomNavBarColors colors;

  static const List<_BottomNavItem> _items = [
    _BottomNavItem(label: 'Cerca', icon: Icons.search_rounded),
    _BottomNavItem(label: 'Linee', icon: Icons.layers_rounded),
    _BottomNavItem(label: 'Impostazioni', icon: Icons.settings_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    final activeIndex = _safeSelectedIndex(selectedIndex);

    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          height: 63,
          padding: const EdgeInsets.all(7.2),
          decoration: BoxDecoration(
            color: colors.backgroundColor,
            borderRadius: BorderRadius.circular(25.2),
            border: Border.all(color: colors.borderColor),
            boxShadow: [
              BoxShadow(
                color: colors.shadowColor,
                blurRadius: 25.2,
                offset: const Offset(0, 9),
              ),
            ],
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final itemWidth = constraints.maxWidth / _items.length;

              return Stack(
                children: [
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 260),
                    curve: Curves.easeOutCubic,
                    left: itemWidth * activeIndex,
                    top: 0,
                    bottom: 0,
                    width: itemWidth,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3.6),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: colors.selectedBackgroundColor,
                          borderRadius: BorderRadius.circular(23.4),
                          boxShadow: [
                            BoxShadow(
                              color: colors.selectedGlowColor,
                              blurRadius: 16.2,
                              offset: const Offset(0, 5.4),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: List.generate(_items.length, (index) {
                      final item = _items[index];
                      final isSelected = activeIndex == index;

                      return Expanded(
                        child: _BottomNavTile(
                          item: item,
                          isSelected: isSelected,
                          colors: colors,
                          onTap: () => onItemSelected(index),
                        ),
                      );
                    }),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  int _safeSelectedIndex(int index) {
    if (index < 0) return 0;
    if (index >= _items.length) return _items.length - 1;
    return index;
  }
}

class _BottomNavTile extends StatelessWidget {
  const _BottomNavTile({
    required this.item,
    required this.isSelected,
    required this.colors,
    required this.onTap,
  });

  final _BottomNavItem item;
  final bool isSelected;
  final BottomNavBarColors colors;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final effectiveColor = isSelected
        ? colors.selectedColor
        : colors.unselectedColor;

    return Semantics(
      button: true,
      selected: isSelected,
      label: item.label,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(23.4),
          splashColor: colors.splashColor,
          highlightColor: colors.highlightColor,
          onTap: onTap,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            opacity: isSelected ? 1 : 0.72,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedScale(
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOut,
                  scale: isSelected ? 1.08 : 1.0,
                  child: Icon(
                    item.icon,
                    color: effectiveColor,
                    size: isSelected ? 22.5 : 20.7,
                  ),
                ),
                const SizedBox(height: 3.6),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOut,
                  style: TextStyle(
                    color: effectiveColor,
                    fontSize: isSelected ? 10.8 : 10.35,
                    height: 1.0,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                    letterSpacing: 0.135,
                  ),
                  child: Text(
                    item.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomNavItem {
  const _BottomNavItem({required this.label, required this.icon});

  final String label;
  final IconData icon;
}
