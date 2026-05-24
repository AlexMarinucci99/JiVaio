import 'package:flutter/material.dart';

import '../line_card/line_card_colors.dart';
import 'line_detail_time_filter.dart';

class LineDetailDeparturesCard extends StatelessWidget {
  const LineDetailDeparturesCard({
    super.key,
    required this.lineColor,
    this.colors = LineCardColors.defaultPalette,
  });

  final Color lineColor;
  final LineCardPalette colors;

  static const String _selectedTimeRange = '17:00 - 18:00';
  static const List<String> _departures = ['17:00', '17:40'];

  @override
  Widget build(BuildContext context) {
    final textOnLineColor = LineCardColors.textOn(
      lineColor,
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
            selectedTimeRange: _selectedTimeRange,
            onTap: () {
              showLineDetailTimeFilterSheet(
                context,
                colors: colors,
              );
            },
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

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _departures.map((departure) {
                final isFirst = departure == _departures.first;

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: _DepartureChip(
                    label: departure,
                    isSelected: isFirst,
                    lineColor: lineColor,
                    selectedTextColor: textOnLineColor,
                    colors: colors,
                  ),
                );
              }).toList(growable: false),
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
      color: const Color(0xFFF3F6FB),
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