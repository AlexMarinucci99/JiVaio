import 'package:flutter/material.dart';

import '../../../../domain/models/transit_line.dart';
import 'line_badge.dart';
import 'line_card_colors.dart';
import 'line_info_pill.dart';
import 'line_save_button.dart';

class LineCardHeader extends StatelessWidget {
  const LineCardHeader({
    super.key,
    required this.line,
    required this.direction,
    required this.lineColor,
    required this.isSaved,
    required this.onToggleSaved,
  });

  final TransitLine line;
  final TransitLineDirection direction;
  final Color lineColor;
  final bool isSaved;
  final VoidCallback onToggleSaved;

  @override
  Widget build(BuildContext context) {
    final badgeTextColor = LineCardColors.textOn(lineColor);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LineBadge(
          shortName: line.shortName,
          backgroundColor: lineColor,
          textColor: badgeTextColor,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nome principale linea.
              Text(
                line.displayName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: LineCardColors.primaryText,
                  fontSize: 14.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),

              // Descrizione linea.
              Text(
                line.routeLongName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: LineCardColors.secondaryText,
                  fontSize: 11.5,
                ),
              ),
              const SizedBox(height: 10),

              // Pill numero fermate.
              LineInfoPill(
                icon: Icons.place_rounded,
                label: _stopCountLabel(direction.stopCount),
              ),
            ],
          ),
        ),

        // Bottone salva linea.
        LineSaveButton(isSaved: isSaved, onPressed: onToggleSaved),
      ],
    );
  }

  String _stopCountLabel(int count) {
    if (count == 1) {
      return '1 fermata';
    }

    return '$count fermate';
  }
}
