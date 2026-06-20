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
    final departureAccent = colors.listAccent;

    final textOnDepartureAccent = LineCardColors.textOn(
      departureAccent,
      colors: colors,
    );

    return Container(
      decoration: LineCardColors.cardDecoration(colors: colors),
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Prossime partenze',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: colors.primaryText,
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Fascia oraria',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: colors.mutedText,
              fontSize: 10.2,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 6),
          _TimeRangeSelector(
            colors: colors,
            selectedTimeRange: selectedTimeRange,
            onTap: onSelectTimeRange,
          ),
          const SizedBox(height: 12),
          Text(
            'Corse disponibili',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: colors.mutedText,
              fontSize: 10.2,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          if (isLoading)
            const _DeparturesLoadingBox()
          else if (departures.isEmpty)
            _EmptyDeparturesBox(message: emptyMessage, colors: colors)
          else
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: departures
                    .map((departure) {
                      final isSelected = departure.tripId == selectedTripId;

                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: _DepartureChip(
                          label: departure.departureTime,
                          isSelected: isSelected,
                          accentColor: departureAccent,
                          selectedTextColor: textOnDepartureAccent,
                          colors: colors,
                        ),
                      );
                    })
                    .toList(growable: false),
              ),
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
    return Material(
      color: LineDetailColors.softSurface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
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
    required this.accentColor,
    required this.selectedTextColor,
    required this.colors,
  });

  final String label;
  final bool isSelected;
  final Color accentColor;
  final Color selectedTextColor;
  final LineCardPalette colors;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isSelected
        ? accentColor
        : accentColor.withValues(alpha: 0.08);

    final borderColor = isSelected
        ? accentColor
        : accentColor.withValues(alpha: 0.18);

    final textColor = isSelected ? selectedTextColor : accentColor;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: textColor,
          fontSize: 12.5,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _DeparturesLoadingBox extends StatelessWidget {
  const _DeparturesLoadingBox();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
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
  }
}

class _EmptyDeparturesBox extends StatelessWidget {
  const _EmptyDeparturesBox({required this.message, required this.colors});

  final String message;
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
        message,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: const Color.fromARGB(255, 56, 4, 139),
          fontSize: 12,
          height: 1.35,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
