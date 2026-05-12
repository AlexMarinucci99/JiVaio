import 'package:flutter/material.dart';

// Navbar inferiore condivisa dell'app.
// Riceve il tab selezionato e comunica alla schermata padre il cambio tab.
class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  // Indice del tab attualmente selezionato.
  final int selectedIndex;

  // Callback chiamata quando l'utente seleziona un tab.
  final ValueChanged<int> onItemSelected;

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
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.16),
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
    required this.onTap,
  });

  final _BottomNavItem item;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const selectedColor = Color(0xFF102A6B);
    const unselectedColor = Color(0xFF9AA3AD);
    const selectedBackgroundColor = Color(0xFFEAF2FF);

    final effectiveColor = isSelected ? selectedColor : unselectedColor;

    return Semantics(
      button: true,
      selected: isSelected,
      label: item.label,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
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
                    ? selectedBackgroundColor
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                item.icon,
                color: effectiveColor,
                size: 24,
              ),
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
