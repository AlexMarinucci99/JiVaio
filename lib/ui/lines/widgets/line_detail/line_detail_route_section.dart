import 'package:flutter/material.dart';

import '../../../../domain/models/transit_line.dart';
import '../../theme/line_card_colors.dart';
import '../../theme/line_detail_colors.dart';
import 'line_detail_stop_tile.dart';
import 'line_detail_trip_empty.dart';

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

  @override
  Widget build(BuildContext context) {
    const colors = LineCardColors.defaultPalette;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: LineCardColors.cardDecoration(colors: colors),
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Elenco fermate', style: textTheme.lineDetailCardTitle(colors)),
          const SizedBox(height: 5),
          Text(
            'Fermate ordinate della tratta selezionata.',
            style: textTheme.lineDetailCardDescription(colors),
          ),
          const SizedBox(height: 14),
          if (stops.isEmpty)
            const LineDetailTripEmpty(
              message: 'Fermate non disponibili per questa direzione.',
              textColor: LineDetailColors.emptyRouteText,
            ),
          for (final (index, stop) in stops.indexed)
            LineDetailStopTile(
              stop: stop,
              isFirst: index == 0,
              isLast: index == stops.length - 1,
              isSelected: selectedStopId == stop.stopId,
              onTap: isStopSelectionEnabled
                  ? () => onStopSelected(stop.stopId)
                  : null,
            ),
        ],
      ),
    );
  }
}
