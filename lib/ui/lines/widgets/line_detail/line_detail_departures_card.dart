import 'package:flutter/material.dart';

import '../../../../domain/models/transit_line.dart';
import '../../theme/line_card_colors.dart';
import '../../theme/line_detail_colors.dart';

/// Card che mostra le partenze disponibili nel dettaglio linea.
///
/// Espone la fascia oraria selezionata, lo stato di caricamento
/// e l'elenco delle corse calcolate dal ViewModel.
class LineDetailDeparturesCard extends StatelessWidget {
  const LineDetailDeparturesCard({
    super.key,
    required this.selectedTimeRange,
    required this.departures,
    required this.onSelectTimeRange,
  });

  final String selectedTimeRange;

  /// Partenze disponibili per la direzione e la fascia selezionate.
  final List<TransitLineDeparture> departures;
  final VoidCallback onSelectTimeRange;

  @override
  Widget build(BuildContext context) {
    const colors = LineCardColors.defaultPalette;
    final textTheme = Theme.of(context).textTheme;

    final sectionLabelStyle = textTheme.labelLarge?.copyWith(
      color: colors.mutedText,
      fontSize: 10.2,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.5,
    );

    return Container(
      decoration: LineCardColors.cardDecoration(colors: colors),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Prossime partenze',
            style: textTheme.lineDetailCardTitle(colors),
          ),
          const SizedBox(height: 12),
          Text('Fascia oraria', style: sectionLabelStyle),
          const SizedBox(height: 6),
          _TimeRangeSelector(
            selectedTimeRange: selectedTimeRange,
            onTap: onSelectTimeRange,
          ),
          const SizedBox(height: 12),
          Text('Corse disponibili', style: sectionLabelStyle),
          const SizedBox(height: 8),
          if (departures.isEmpty)
            const Text('Nessuna corsa disponibile.')
          else
            Row(
              spacing: 8,
              children: [
                for (final departure in departures)
                  _DepartureChip(
                    label: departure.departureTime,
                    isSelected: departure.tripId == departures.first.tripId,
                  ),
              ],
            ),
        ],
      ),
    );
  }
}

class _TimeRangeSelector extends StatelessWidget {
  const _TimeRangeSelector({
    required this.selectedTimeRange,
    required this.onTap,
  });

  final String selectedTimeRange;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const colors = LineCardColors.defaultPalette;
    const borderRadius = BorderRadius.all(Radius.circular(16));

    return Material(
      color: LineDetailColors.softSurface,
      borderRadius: borderRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius,
        child: Ink(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            border: Border.all(color: colors.border),
          ),
          child: Row(
            children: [
              Icon(
                Icons.access_time_rounded,
                color: colors.primaryText,
                size: 18,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  selectedTimeRange,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: colors.primaryText,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                color: colors.secondaryText,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DepartureChip extends StatelessWidget {
  const _DepartureChip({required this.label, required this.isSelected});

  final String label;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    const colors = LineCardColors.defaultPalette;
    final accentColor = colors.listAccent;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: isSelected ? accentColor : accentColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isSelected ? accentColor : accentColor.withValues(alpha: 0.18),
        ),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: isSelected
              ? LineCardColors.textOn(accentColor, colors: colors)
              : accentColor,
          fontSize: 12.5,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
