import 'package:flutter/material.dart';

import '../../../../domain/models/transit_line.dart';
import '../../theme/line_card_colors.dart';
import '../../theme/line_detail_colors.dart';
import 'line_detail_stop_tile.dart';

class LineDetailRouteSection extends StatelessWidget {
  const LineDetailRouteSection({
    super.key,
    required this.stops,
    required this.lineColor,
    required this.selectedStopId,
    required this.isStopSelectionEnabled,
    required this.onStopSelected,
    this.colors = LineCardColors.defaultPalette,
  });

  final List<TransitLineStop> stops;
  final Color lineColor;
  final String? selectedStopId;
  final bool isStopSelectionEnabled;
  final ValueChanged<String> onStopSelected;
  final LineCardPalette colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: LineCardColors.cardDecoration(colors: colors),
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Elenco fermate',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: colors.primaryText,
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Fermate ordinate della tratta selezionata.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: colors.secondaryText,
              fontSize: 12,
              height: 1.35,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 14),
          if (stops.isEmpty)
            _EmptyRouteBox(colors: colors)
          else
            ...stops.asMap().entries.map((entry) {
              final index = entry.key;
              final stop = entry.value;

              return LineDetailStopTile(
                key: ValueKey(stop.stopId),
                stop: stop,
                lineColor: lineColor,
                isFirst: index == 0,
                isLast: index == stops.length - 1,
                isSelected: selectedStopId == stop.stopId,
                isSelectionEnabled: isStopSelectionEnabled,
                onTap: () => onStopSelected(stop.stopId),
                colors: colors,
              );
            }),
        ],
      ),
    );
  }
}

class _EmptyRouteBox extends StatelessWidget {
  const _EmptyRouteBox({required this.colors});

  final LineCardPalette colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 11, 12, 11),
      decoration: BoxDecoration(
        color: LineDetailColors.warningSurface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        'Fermate non disponibili per questa direzione.',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: const Color.fromARGB(255, 4, 11, 117),
          fontSize: 12,
          height: 1.35,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
