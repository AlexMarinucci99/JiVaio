import 'package:flutter/material.dart';

import '../theme/bottom_nav_bar_colors.dart';

/// Mostra la barra di navigazione inferiore dell'app.
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
      child: Container(
        height: 63,
        padding: const EdgeInsets.all(7.2),
        decoration: BoxDecoration(
          color: colors.backgroundColor,
          borderRadius: BorderRadius.circular(25.2),
          border: Border.all(color: colors.borderColor),
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
      excludeSemantics: true,
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
