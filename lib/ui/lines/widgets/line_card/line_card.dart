import 'package:flutter/material.dart';

import '../../../../domain/models/transit_line.dart';
import 'line_card_colors.dart';
import 'line_card_header.dart';
import 'line_route_preview.dart';

class LineCard extends StatefulWidget {
  const LineCard({
    super.key,
    required this.line,
    required this.isSaved,
    required this.onToggleSaved,
    required this.onOpenDetails,
  });

  final TransitLine line;
  final bool isSaved;
  final VoidCallback onToggleSaved;
  final VoidCallback onOpenDetails;

  @override
  State<LineCard> createState() => _LineCardState();
}

class _LineCardState extends State<LineCard> {
  int _selectedDirectionIndex = 0;

  TransitLineDirection get _selectedDirection {
    return widget.line.directions[_selectedDirectionIndex];
  }

  void _toggleDirection() {
    if (widget.line.directions.length < 2) {
      return;
    }

    setState(() {
      _selectedDirectionIndex = _selectedDirectionIndex == 0 ? 1 : 0;
    });
  }

  @override
  void didUpdateWidget(covariant LineCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.line.routeId != widget.line.routeId) {
      _selectedDirectionIndex = 0;
      return;
    }

    if (_selectedDirectionIndex >= widget.line.directions.length) {
      _selectedDirectionIndex = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final lineColor = LineCardColors.parseLineColor(widget.line.routeColor);
    final direction = _selectedDirection;

    return Container(
      decoration: LineCardColors.cardDecoration(),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
        child: Column(
          children: [
            LineCardHeader(
              line: widget.line,
              direction: direction,
              lineColor: lineColor,
              isSaved: widget.isSaved,
              onToggleSaved: widget.onToggleSaved,
            ),

            const SizedBox(height: 14),

            LineRoutePreview(
              line: widget.line,
              direction: direction,
              lineColor: lineColor,
              canSwapDirection: widget.line.directions.length > 1,
              onSwapDirection: _toggleDirection,
              onOpenDetails: widget.onOpenDetails,
            ),
          ],
        ),
      ),
    );
  }
}
