import 'package:flutter/material.dart';

import '../../../../domain/models/transit_line.dart';
import '../line_card/line_card_colors.dart';
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

  // Palette privata della schermata dettaglio linea.
  static const _LineDetailScreenColors _colors = _LineDetailScreenColors();

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
    final lineColor = LineCardColors.parseLineColor(
      widget.line.routeColor,
      colors: _colors.linePalette,
    );

    return Scaffold(
      backgroundColor: _colors.backgroundColor,
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFF6FAFF),
              Color(0xFFF2F6FC),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // Header fisso superiore.
              LineDetailHeader(
                line: widget.line,
                direction: _selectedDirection,
                lineColor: lineColor,
                canSwapDirection: widget.line.directions.length > 1,
                onSwapDirection: _toggleDirection,
                onClose: () => Navigator.of(context).pop(),
                colors: _colors.linePalette,
              ),

              const SizedBox(height: 12),

              // Per ora il corpo rimane vuoto.
              const Expanded(
                child: SizedBox.expand(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Colori specifici della schermata dettaglio linea.
class _LineDetailScreenColors {
  const _LineDetailScreenColors();

  final Color backgroundColor = const Color(0xFFF6FAFF);

  // Palette condivisa con la feature linee.
  // Non modifica il colore del badge: quello resta derivato da line.routeColor.
  final LineCardPalette linePalette = LineCardColors.defaultPalette;
}