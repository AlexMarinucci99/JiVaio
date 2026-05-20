import 'package:flutter/material.dart';

class BottomNavBarColors {
  const BottomNavBarColors({
    this.backgroundColor = Colors.white,
    this.shadowColor = const Color(0x29000000),
    this.selectedColor = const Color(0xFF102A6B),
    this.unselectedColor = const Color(0xFF9AA3AD),
    this.selectedBackgroundColor = const Color(0xFFEAF2FF),
    this.splashColor = const Color(0x14102A6B),
    this.highlightColor = const Color(0x0A102A6B),
  });

  // Sfondo generale della navbar.
  final Color backgroundColor;

  // Colore dell'ombra sotto la navbar.
  final Color shadowColor;

  // Colore icona/testo del tab selezionato.
  final Color selectedColor;

  // Colore icona/testo dei tab non selezionati.
  final Color unselectedColor;

  // Sfondo della pill dell'icona selezionata.
  final Color selectedBackgroundColor;

  // Colore effetto tap.
  final Color splashColor;

  // Colore effetto pressione.
  final Color highlightColor;
}

// Navbar inferiore condivisa dell'app.
// Riceve il tab selezionato e comunica alla schermata padre il cambio tab.
class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    this.colors = const BottomNavBarColors(),
  });

  // Indice del tab attualmente selezionato.
  final int selectedIndex;

  // Callback chiamata quando l'utente seleziona un tab.
  final ValueChanged<int> onItemSelected;

  // Palette colori propria della navbar.
  final BottomNavBarColors colors;

  static const List<_BottomNavItem> _items = [
    _BottomNavItem(label: 'Cerca', icon: Icons.search_rounded),
    _BottomNavItem(label: 'Linee', icon: Icons.layers_rounded),
    _BottomNavItem(label: 'Impostazioni', icon: Icons.settings_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: colors.backgroundColor,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: colors.shadowColor,
            blurRadius: 22,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: List.generate(_items.length, (index) {
          final item = _items[index];
          final isSelected = selectedIndex == index;

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
    );
  }
}

// Singolo elemento della navbar.
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
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        splashColor: colors.splashColor,
        highlightColor: colors.highlightColor,
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Box superiore dell'icona.
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOut,
              width: 72,
              height: 34,
              decoration: BoxDecoration(
                color: isSelected
                    ? colors.selectedBackgroundColor
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(item.icon, color: effectiveColor, size: 24),
            ),

            const SizedBox(height: 2),

            // Testo sotto l'icona.
            Text(
              item.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: effectiveColor,
                fontSize: 12,
                height: 1.0,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Modello interno di un tab della navbar.
class _BottomNavItem {
  const _BottomNavItem({required this.label, required this.icon});

  final String label;
  final IconData icon;
}