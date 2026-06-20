import 'package:flutter/material.dart';

import '../../../../domain/models/transit_line.dart';
import 'line_badge.dart';
import '../../theme/line_card_colors.dart';
import 'line_info_pill.dart';
import 'line_save_button.dart';

/// Header della card che sintetizza le informazioni principali di una linea.
///
/// Mostra badge, nome, descrizione, numero di fermate della direzione
/// selezionata e azione di salvataggio.
class LineCardHeader extends StatelessWidget {
  const LineCardHeader({
    super.key,
    required this.line,
    required this.direction,
    required this.isSaved,
    required this.onToggleSaved,
    this.colors = LineCardColors.defaultPalette,
  });

  ///linea rappresentata
  final TransitLine line;

  ///direzione rappresentata usata per visualizzare il numero di fermate.
  final TransitLineDirection direction;

  final bool isSaved;

  /// Callback eseguita quando l'utente aggiorna lo stato di salvataggio.
  final VoidCallback onToggleSaved;

  // Palette propria dell'header della card.
  final LineCardPalette colors;

  @override
  Widget build(BuildContext context) {
    final badgeColor = colors.listAccent;

    final badgeTextColor = LineCardColors.textOn(badgeColor, colors: colors);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LineBadge(
          shortName: line.shortName,
          backgroundColor: badgeColor,
          textColor: badgeTextColor,
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                line.displayName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: colors.primaryText,
                  fontSize: 14.5,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                line.routeLongName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colors.secondaryText,
                  fontSize: 11.5,
                ),
              ),

              const SizedBox(height: 10),

              LineInfoPill(
                icon: Icons.place_rounded,
                label: _stopCountLabel(direction.stopCount),
                colors: colors,
              ),
            ],
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

  String _stopCountLabel(int count) {
    if (count == 1) {
      return '1 fermata';
    }

    return '$count fermate';
  }
}
