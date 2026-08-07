import 'package:flutter/material.dart';

import '../../../../domain/models/transit_line.dart';
import '../../theme/line_card_colors.dart';
import 'line_card_header.dart';
import 'line_route_preview.dart';

/// Card che mostra una linea urbana nell'elenco linee.
///
/// Gestisce localmente la direzione selezionata e delega al chiamante
/// le azioni di salvataggio e apertura del dettaglio.
class LineCard extends StatefulWidget {
  const LineCard({
    super.key,
    required this.line,
    required this.isSaved,
    required this.onToggleSaved,
    required this.onOpenDetails,
    this.colors = LineCardColors.defaultPalette,
  });

  /// Linea da mostrare nella card.
  final TransitLine line;

  final bool isSaved;

  /// Callback eseguita quando l'utente aggiorna lo stato di salvataggio.
  final VoidCallback onToggleSaved;

  /// Callback eseguita quando l'utente apre i dettagli della linea.
  final VoidCallback onOpenDetails;

  /// Palette propria della card linea.
  final LineCardPalette colors;

  @override
  State<LineCard> createState() => _LineCardState();
}

class _LineCardState extends State<LineCard> {
  int _selectedDirectionIndex = 0;

  TransitLineDirection get _selectedDirection =>
      widget.line.directions[_selectedDirectionIndex];

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

    if (oldWidget.line.routeId != widget.line.routeId ||
        _selectedDirectionIndex >= widget.line.directions.length) {
      _selectedDirectionIndex = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final lineColor = LineCardColors.parseLineColor(
      widget.line.routeColor,
      colors: widget.colors,
    );
    final direction = _selectedDirection;

    return Container(
      decoration: LineCardColors.cardDecoration(colors: widget.colors),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          spacing: 14,
          children: [
            LineCardHeader(
              line: widget.line,
              direction: direction,
              isSaved: widget.isSaved,
              onToggleSaved: widget.onToggleSaved,
              colors: widget.colors,
            ),
            LineRoutePreview(
              line: widget.line,
              direction: direction,
              lineColor: lineColor,
              canSwapDirection: widget.line.directions.length > 1,
              onSwapDirection: _toggleDirection,
              onOpenDetails: widget.onOpenDetails,
              colors: widget.colors,
            ),
          ],
        ),
      ),
    );
  }
}
