import 'package:flutter/material.dart';

import '../../../../domain/models/transit_line.dart';
import '../../theme/line_card_colors.dart';
import '../../theme/line_detail_colors.dart';
import 'line_detail_trip_empty.dart';

/// Card che mostra le partenze disponibili nel dettaglio linea.
///
/// Espone la fascia oraria selezionata, lo stato di caricamento
/// e l'elenco delle corse calcolate dal ViewModel.
class LineDetailDeparturesCard extends StatelessWidget {
  const LineDetailDeparturesCard({
    super.key,
    required this.selectedTimeRange,
    required this.departures,
    required this.selectedTripId,
    required this.isLoading,
    required this.emptyMessage,
    required this.onSelectTimeRange,
    this.colors = LineCardColors.defaultPalette,
  });

  final String selectedTimeRange;

  /// Partenze disponibili per la direzione e la fascia selezionate.
  final List<TransitLineDeparture> departures;

  /// Identificativo della corsa selezionata.
  ///
  /// È null quando non è ancora stata selezionata una corsa.
  final String? selectedTripId;

  /// Indica se il caricamento delle partenze è ancora in corso.
  final bool isLoading;

  /// Messaggio mostrato quando non sono disponibili partenze.
  final String emptyMessage;

  /// Callback eseguita quando l'utente seleziona una nuova fascia oraria.
  final VoidCallback onSelectTimeRange;

  final LineCardPalette colors;

  @override
  Widget build(BuildContext context) {
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
            colors: colors,
            selectedTimeRange: selectedTimeRange,
            onTap: onSelectTimeRange,
          ),
          const SizedBox(height: 12),
          Text('Corse disponibili', style: sectionLabelStyle),
          const SizedBox(height: 8),
          if (isLoading)
            _departuresLoadingBox
          else if (departures.isEmpty)
            LineDetailTripEmpty(
              message: emptyMessage,
              textColor: LineDetailColors.emptyDeparturesText,
            )
          else
            Row(
              children: [
                for (final departure in departures)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _DepartureChip(
                      label: departure.departureTime,
                      isSelected: departure.tripId == selectedTripId,
                      colors: colors,
                    ),
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
    required this.colors,
    required this.selectedTimeRange,
    required this.onTap,
  });

  final LineCardPalette colors;
  final String selectedTimeRange;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
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
  const _DepartureChip({
    required this.label,
    required this.isSelected,
    required this.colors,
  });

  final String label;
  final bool isSelected;
  final LineCardPalette colors;

  @override
  Widget build(BuildContext context) {
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

const _departuresLoadingBox = SizedBox(
  height: 38,
  child: Align(
    alignment: Alignment.centerLeft,
    child: SizedBox(
      width: 22,
      height: 22,
      child: CircularProgressIndicator(strokeWidth: 2.4),
    ),
  ),
);
