import 'package:flutter/material.dart';

import '../../../../domain/models/transit_line.dart';
import 'line_badge.dart';
import '../../theme/line_card_colors.dart';
import 'line_save_button.dart';

/// Header della card che sintetizza le informazioni principali di una linea.
///
/// Mostra badge, nome e azione di salvataggio.
class LineCardHeader extends StatelessWidget {
  const LineCardHeader({
    super.key,
    required this.line,
    required this.isSaved,
    required this.onToggleSaved,
    this.colors = LineCardColors.defaultPalette,
  });

  ///linea rappresentata
  final TransitLine line;

  final bool isSaved;

  /// Callback eseguita quando l'utente aggiorna lo stato di salvataggio.
  final VoidCallback onToggleSaved;

  // Palette propria dell'header della card.
  final LineCardPalette colors;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LineBadge(shortName: line.shortName, colors: colors),

        const SizedBox(width: 12),

        Expanded(
          child: Text(
            line.displayName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: colors.primaryText,
              fontSize: 14.5,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),

        LineSaveButton(
          isSaved: isSaved,
          onPressed: onToggleSaved,
          colors: colors,
        ),
      ],
    );
  }
}
