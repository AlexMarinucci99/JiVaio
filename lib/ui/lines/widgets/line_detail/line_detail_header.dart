import 'package:flutter/material.dart';

import '../../../../domain/models/transit_line.dart';
import '../../theme/line_card_colors.dart';
import '../../theme/line_detail_colors.dart';
import '../line_card/line_badge.dart';
import '../line_card/line_central_label.dart';
import '../line_card/line_direction_button.dart';
import '../line_card/line_info_pill.dart';

/// Header della schermata dettaglio linea.
///
/// Mostra le informazioni principali della linea, la direzione selezionata
/// e i controlli per tornare all'elenco o invertire il senso di percorrenza.
class LineDetailHeader extends StatelessWidget {
  const LineDetailHeader({
    super.key,
    required this.line,
    required this.direction,
    required this.canSwapDirection,
    required this.onSwapDirection,
    required this.onClose,
    this.colors = LineCardColors.defaultPalette,
  });

  final TransitLine line;

  /// Direzione attualmente selezionata.
  ///
  /// È null quando la linea non ha una direzione disponibile.
  final TransitLineDirection? direction;

  /// Indica se l'utente può invertire la direzione visualizzata.
  final bool canSwapDirection;

  /// Callback eseguita quando l'utente inverte la direzione.
  final VoidCallback onSwapDirection;

  /// Callback eseguita quando l'utente torna alla schermata precedente.
  final VoidCallback onClose;

  // Palette condivisa della feature linee.
  final LineCardPalette colors;

  @override
  Widget build(BuildContext context) {
    final badgeColor = colors.listAccent;

    final badgeTextColor = LineCardColors.textOn(badgeColor, colors: colors);

    final selectedDirection = direction;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      decoration: LineCardColors.cardDecoration(colors: colors),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 14, 14, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Material(
                  color: colors.pillBackground,
                  shape: const CircleBorder(),
                  child: IconButton(
                    tooltip: 'Torna alle linee',
                    icon: const Icon(Icons.arrow_back_rounded, size: 20),
                    color: colors.primaryText,
                    onPressed: onClose,
                  ),
                ),

                const SizedBox(width: 10),
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
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: colors.primaryText,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          height: 1.15,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        line.routeLongName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colors.secondaryText,
                          fontSize: 11.5,
                        ),
                      ),

                      if (selectedDirection != null) ...[
                        const SizedBox(height: 10),

                        LineInfoPill(
                          icon: Icons.place_rounded,
                          label: _stopCountLabel(selectedDirection.stopCount),
                          colors: colors,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),

          Container(height: 1, color: colors.border),

          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
            child: selectedDirection == null
                ? _DirectionUnavailableBox(colors: colors)
                : _DirectionSwitcherBox(
                    direction: selectedDirection,
                    isUnidirectional: line.isUnidirectional,
                    canSwapDirection: canSwapDirection,
                    onSwapDirection: onSwapDirection,
                    colors: colors,
                  ),
          ),
        ],
      ),
    );
  }

  String _stopCountLabel(int count) {
    if (count == 1) {
      return '1 fermata';
    }

    return '$count fermate';
  }
}

class _DirectionSwitcherBox extends StatelessWidget {
  const _DirectionSwitcherBox({
    required this.direction,
    required this.isUnidirectional,
    required this.canSwapDirection,
    required this.onSwapDirection,
    required this.colors,
  });

  final TransitLineDirection direction;
  final bool isUnidirectional;
  final bool canSwapDirection;
  final VoidCallback onSwapDirection;
  final LineCardPalette colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: LineDetailColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: LineCentralLabel(
              caption: 'Partenza',
              value: direction.originName,
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
          ),

          LineDirectionButton(
            isUnidirectional: isUnidirectional,
            canSwapDirection: canSwapDirection,
            onSwapDirection: onSwapDirection,
            iconSize: 20,
            colors: colors,
          ),

          Expanded(
            child: LineCentralLabel(
              caption: 'Capolinea',
              value: direction.destinationName,
              crossAxisAlignment: CrossAxisAlignment.end,
            ),
          ),
        ],
      ),
    );
  }
}

class _DirectionUnavailableBox extends StatelessWidget {
  const _DirectionUnavailableBox({required this.colors});

  final LineCardPalette colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: colors.pillBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border),
      ),
      child: Text(
        'Direzione non disponibile',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          fontSize: 12,
          color: colors.secondaryText,
        ),
      ),
    );
  }
}
