import 'package:flutter/material.dart';

import '../../../../domain/models/transit_line.dart';
import '../../theme/line_card_colors.dart';
import '../../theme/line_detail_colors.dart';
import 'line_detail_stop_tile.dart';

/// Sezione che mostra le fermate della direzione selezionata.
///
/// Supporta anche la selezione di una fermata quando la schermata
/// dettaglio viene usata per completare una segnalazione.
class LineDetailRouteSection extends StatelessWidget {
  const LineDetailRouteSection({
    super.key,
    required this.stops,
    required this.selectedStopId,
    required this.isStopSelectionEnabled,
    required this.onStopSelected,
    this.colors = LineCardColors.defaultPalette,
  });

  /// Fermate ordinate della direzione visualizzata.
  final List<TransitLineStop> stops;

  /// Identificativo della fermata selezionata.
  ///
  /// È null quando nessuna fermata è selezionata.
  final String? selectedStopId;

  /// Indica se l'utente può selezionare una fermata dall'elenco.
  final bool isStopSelectionEnabled;

  /// Callback eseguita quando l'utente seleziona una fermata.
  final ValueChanged<String> onStopSelected;

  final LineCardPalette colors;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: LineCardColors.cardDecoration(colors: colors),
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Elenco fermate',
            style: textTheme.titleMedium?.copyWith(
              color: colors.primaryText,
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Fermate ordinate della tratta selezionata.',
            style: textTheme.bodySmall?.copyWith(
              color: colors.secondaryText,
              fontSize: 12,
              height: 1.35,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 14),
          if (stops.isEmpty) const _EmptyRouteBox(),
          for (final (index, stop) in stops.indexed)
            LineDetailStopTile(
              key: ValueKey('route-stop-$index-${stop.stopId}'),
              stop: stop,
              isFirst: index == 0,
              isLast: index == stops.length - 1,
              isSelected: selectedStopId == stop.stopId,
              onTap: isStopSelectionEnabled
                  ? () => onStopSelected(stop.stopId)
                  : null,
              colors: colors,
            ),
        ],
      ),
    );
  }
}

class _EmptyRouteBox extends StatelessWidget {
  const _EmptyRouteBox();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      decoration: BoxDecoration(
        color: LineDetailColors.warningSurface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        'Fermate non disponibili per questa direzione.',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: LineDetailColors.emptyRouteText,
          fontSize: 12,
          height: 1.35,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
