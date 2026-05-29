import 'package:flutter/material.dart';

import '../../../../domain/models/transit_line.dart';

// Widget già esistenti della card linea, riutilizzati anche nel dettaglio.
import '../line_card/line_badge.dart';
import '../line_card/line_card_colors.dart';
import '../line_card/line_central_label.dart';
import '../line_card/line_info_pill.dart';

class LineDetailHeader extends StatelessWidget {
  const LineDetailHeader({
    super.key,
    required this.line,
    required this.direction,
    required this.lineColor,
    required this.canSwapDirection,
    required this.onSwapDirection,
    required this.onClose,
    this.colors = LineCardColors.defaultPalette,
  });

  final TransitLine line;
  final TransitLineDirection? direction;
  final Color lineColor;
  final bool canSwapDirection;
  final VoidCallback onSwapDirection;
  final VoidCallback onClose;

  // Palette condivisa della feature linee.
  // Non controlla il colore del badge: il badge continua a usare lineColor.
  final LineCardPalette colors;

  @override
  Widget build(BuildContext context) {
    // Calcola il colore del testo leggibile sopra il colore reale della linea.
    final textColor = LineCardColors.textOn(lineColor, colors: colors);

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
                // Bottone freccia per tornare alla schermata elenco linee.
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

                // Riutilizzo di LineBadge: stesso badge linea già usato nelle card.
                // Il colore resta quello della linea, non della palette.
                LineBadge(
                  shortName: line.shortName,
                  backgroundColor: lineColor,
                  textColor: textColor,
                ),

                const SizedBox(width: 12),

                // Area testuale specifica del dettaglio linea.
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

                        // Riutilizzo di LineInfoPill: pill informativa già usata nelle card.
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

          // Separatore interno dell'header.
          Container(height: 1, color: colors.border),

          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
            child: selectedDirection == null
                ? _DirectionUnavailableBox(colors: colors)
                : _DirectionSwitcherBox(
                    direction: selectedDirection,
                    lineColor: lineColor,
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
    required this.lineColor,
    required this.isUnidirectional,
    required this.canSwapDirection,
    required this.onSwapDirection,
    required this.colors,
  });

  final TransitLineDirection direction;
  final Color lineColor;
  final bool isUnidirectional;
  final bool canSwapDirection;
  final VoidCallback onSwapDirection;
  final LineCardPalette colors;

  @override
  Widget build(BuildContext context) {
    final supportsDirectionSwap = canSwapDirection && !isUnidirectional;
    final showsOneWayDirection = isUnidirectional;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        // Sfondo bianco del box Partenza / Capolinea.
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border),
      ),
      child: Row(
        children: [
          Expanded(
            // Riutilizzo di LineCentralLabel: label già usata anche nella card linea.
            child: LineCentralLabel(
              caption: 'Partenza',
              value: direction.originName,
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
          ),

          // Bottone centrale per invertire la direzione.
          Material(
            color: lineColor.withValues(alpha: 0.12),
            shape: const CircleBorder(),
            child: IconButton(
              visualDensity: VisualDensity.compact,
              onPressed: supportsDirectionSwap ? onSwapDirection : null,
              icon: Icon(
                showsOneWayDirection
                    ? Icons.arrow_forward_rounded
                    : Icons.swap_horiz_rounded,
                color: supportsDirectionSwap || showsOneWayDirection
                    ? lineColor
                    : colors.mutedText,
                size: 20,
              ),
              tooltip: supportsDirectionSwap
                  ? 'Inverti direzione'
                  : 'Direzione unica',
            ),
          ),

          Expanded(
            // Riutilizzo di LineCentralLabel: stessa struttura per il capolinea.
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
