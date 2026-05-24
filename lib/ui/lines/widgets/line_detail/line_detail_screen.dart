import 'package:flutter/material.dart';

import '../../../../domain/models/transit_line.dart';
import '../line_card/line_card_colors.dart';
import 'line_detail_departures_card.dart';
import 'line_detail_header.dart';

class LineDetailScreen extends StatefulWidget {
  const LineDetailScreen({
    super.key,
    required this.line,
  });

  final TransitLine line;

  @override
  State<LineDetailScreen> createState() => _LineDetailScreenState();
}

class _LineDetailScreenState extends State<LineDetailScreen> {
  int _selectedDirectionIndex = 0;

  TransitLineDirection? get _selectedDirection {
    if (widget.line.directions.isEmpty) {
      return null;
    }

    if (_selectedDirectionIndex >= widget.line.directions.length) {
      return widget.line.directions.first;
    }

    return widget.line.directions[_selectedDirectionIndex];
  }

  void _toggleDirection() {
    if (widget.line.directions.length < 2 || widget.line.isUnidirectional) {
      return;
    }

    setState(() {
      _selectedDirectionIndex =
          (_selectedDirectionIndex + 1) % widget.line.directions.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final lineColor = LineCardColors.parseLineColor(widget.line.routeColor);

    return Scaffold(
      backgroundColor: const Color(0xFFF6FAFF),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Header fisso superiore del dettaglio linea.
            LineDetailHeader(
              line: widget.line,
              direction: _selectedDirection,
              lineColor: lineColor,
              canSwapDirection: widget.line.directions.length > 1,
              onSwapDirection: _toggleDirection,
              onClose: () => Navigator.of(context).pop(),
            ),

            const SizedBox(height: 12),

            // Corpo scrollabile del dettaglio linea.
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(22, 8, 22, 120),
                children: [
                  LineDetailDeparturesCard(
                    lineColor: lineColor,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}