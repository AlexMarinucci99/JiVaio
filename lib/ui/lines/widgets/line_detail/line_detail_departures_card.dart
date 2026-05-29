import 'package:flutter/material.dart';

import '../../../../domain/models/transit_line.dart';
import '../line_card/line_card_colors.dart';
import 'line_detail_colors.dart';

class LineDetailDeparturesCard extends StatelessWidget {
  const LineDetailDeparturesCard({
    super.key,
    required this.lineColor,
    required this.selectedTimeRange,
    required this.departures,
    required this.selectedTripId,
    required this.isLoading,
    required this.emptyMessage,
    required this.onSelectTimeRange,
    this.colors = LineCardColors.defaultPalette,
  });

  final Color lineColor;
  final String selectedTimeRange;
  final List<TransitLineDeparture> departures;
  final String? selectedTripId;
  final bool isLoading;
  final String emptyMessage;
  final VoidCallback onSelectTimeRange;
  final LineCardPalette colors;

  @override
  Widget build(BuildContext context) {
    final textOnLineColor = LineCardColors.textOn(lineColor, colors: colors);

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
                          lineColor: lineColor,
                          selectedTextColor: textOnLineColor,
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
    required this.lineColor,
    required this.selectedTextColor,
    required this.colors,
  });

  final String label;
  final bool isSelected;
  final Color lineColor;
  final Color selectedTextColor;
  final LineCardPalette colors;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isSelected
        ? lineColor
        : lineColor.withValues(alpha: 0.08);

    final borderColor = isSelected
        ? lineColor
        : lineColor.withValues(alpha: 0.18);

    final textColor = isSelected ? selectedTextColor : lineColor;

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
          color: LineDetailColors.warningText,
          fontSize: 12,
          height: 1.35,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
