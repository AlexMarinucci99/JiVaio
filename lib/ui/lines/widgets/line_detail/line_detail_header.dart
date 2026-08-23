import 'package:flutter/material.dart';

import '../../../../domain/models/transit_line.dart';
import '../../../core/widgets/back_button.dart';
import '../../theme/line_card_colors.dart';
import '../../theme/line_detail_colors.dart';
import '../line_card/line_badge.dart';
import '../line_card/line_central_label.dart';
import '../line_card/line_direction_button.dart';

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
  });

  final TransitLine line;

  /// Direzione attualmente selezionata.
  ///
  /// È null quando la linea non ha una direzione disponibile.
  final TransitLineDirection? direction;

  final bool canSwapDirection;
  final VoidCallback onSwapDirection;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    const colors = LineCardColors.defaultPalette;
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
                AppBackButton(onPressed: onClose, tooltip: 'Torna alle linee'),

                const SizedBox(width: 10),
                LineBadge(shortName: line.shortName, colors: colors),

                const SizedBox(width: 12),

                Expanded(
                  child: Text(
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
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8),
            child: selectedDirection == null
                ? const _DirectionUnavailableBox()
                : _DirectionSwitcherBox(
                    direction: selectedDirection,
                    isUnidirectional: line.isUnidirectional,
                    canSwapDirection: canSwapDirection,
                    onSwapDirection: onSwapDirection,
                  ),
          ),
        ],
      ),
    );
  }
}

class _DirectionSwitcherBox extends StatelessWidget {
  const _DirectionSwitcherBox({
    required this.direction,
    required this.isUnidirectional,
    required this.canSwapDirection,
    required this.onSwapDirection,
  });

  final TransitLineDirection direction;
  final bool isUnidirectional;
  final bool canSwapDirection;
  final VoidCallback onSwapDirection;

  @override
  Widget build(BuildContext context) {
    const colors = LineCardColors.defaultPalette;

    return Container(
      padding: const EdgeInsets.all(10),
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
 const _DirectionUnavailableBox();

  @override
  Widget build(BuildContext context) {
    const colors = LineCardColors.defaultPalette;
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
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
