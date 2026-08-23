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
  });

  /// Linea da mostrare nella card.
  final TransitLine line;
  final bool isSaved;

  /// Callback eseguita quando l'utente aggiorna lo stato di salvataggio.
  final VoidCallback onToggleSaved;
  final VoidCallback onOpenDetails;

  @override
  State<LineCard> createState() => _LineCardState();
}

class _LineCardState extends State<LineCard> {
  int _selectedDirectionIndex = 0;

  TransitLineDirection get _selectedDirection =>
      widget.line.directions[_selectedDirectionIndex];

  void _toggleDirection() {
    if (widget.line.directions.length < 2) return;

    setState(() {
      _selectedDirectionIndex = _selectedDirectionIndex == 0 ? 1 : 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: LineCardColors.cardDecoration(
        colors: LineCardColors.defaultPalette,
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        spacing: 14,
        children: [
          LineCardHeader(
            line: widget.line,
            isSaved: widget.isSaved,
            onToggleSaved: widget.onToggleSaved,
          ),
          LineRoutePreview(
            line: widget.line,
            direction: _selectedDirection,
            onSwapDirection: _toggleDirection,
            onOpenDetails: widget.onOpenDetails,
          ),
        ],
      ),
    );
  }
}
