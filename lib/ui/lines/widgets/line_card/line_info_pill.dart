import 'package:flutter/material.dart';

import '../../theme/line_card_colors.dart';

/// Pill informativa usata nella card linea.
///
/// Mostra un'icona e un'etichetta, rispettando l'allineamento,
/// usando la palette della card.
class LineInfoPill extends StatelessWidget {
  const LineInfoPill({
    super.key,
    required this.icon,
    required this.label,
    this.colors = LineCardColors.defaultPalette,
  });

  final IconData icon;

  final String label;

  // Palette propria della pill informativa.
  final LineCardPalette colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: colors.pillBackground,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: colors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: colors.secondaryText),
          const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: 10.8,
              color: colors.secondaryText,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
