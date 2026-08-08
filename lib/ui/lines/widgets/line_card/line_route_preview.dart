import 'package:flutter/material.dart';

import '../../../../domain/models/transit_line.dart';
import '../../theme/line_card_colors.dart';
import 'line_central_label.dart';
import 'line_direction_button.dart';

/// Preview sintetica del percorso mostrata nella card della linea.
///
/// Mostra partenza, capolinea, prossime partenze e accesso
/// alla schermata completa della linea.
class LineRoutePreview extends StatelessWidget {
  const LineRoutePreview({
    super.key,
    required this.line,
    required this.direction,
    required this.lineColor,
    required this.canSwapDirection,
    required this.onSwapDirection,
    required this.onOpenDetails,
    this.colors = LineCardColors.defaultPalette,
  });

  ///Linea rappresentata.
  final TransitLine line;

  ///Direzione attualemnte visualizzata nella card.
  final TransitLineDirection direction;

  final Color lineColor;

  final bool canSwapDirection;

  /// Callback eseguita quando l'utente inverte la direzione.
  final VoidCallback onSwapDirection;

  /// Callback eseguita quando l'utente apre i dettagli completi della linea.
  final VoidCallback onOpenDetails;

  // Palette propria della preview percorso.
  final LineCardPalette colors;

  String get _emptyStateMessage => direction.hasServiceToday
      ? 'Nessuna altra partenza disponibile per oggi.'
      : 'Nessuna corsa attiva per oggi.';

  @override
  Widget build(BuildContext context) {
    final actionColor = colors.listAccent;
    final actionTextColor = LineCardColors.textOn(actionColor, colors: colors);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: colors.border),
          ),
          child: Row(
            children: [
              Expanded(
                child: LineCentralLabel(
                  caption: 'Partenza',
                  value: direction.originName,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  colors: colors,
                ),
              ),

              LineDirectionButton(
                isUnidirectional: line.isUnidirectional,
                canSwapDirection: canSwapDirection,
                onSwapDirection: onSwapDirection,
                colors: colors,
              ),

              Expanded(
                child: LineCentralLabel(
                  caption: 'Capolinea',
                  value: direction.destinationName,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  colors: colors,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        Text(
          'Prossime partenze',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: colors.mutedText,
            letterSpacing: 0.6,
            fontSize: 10.5,
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: 8),

        if (direction.hasUpcomingDepartures)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final departure in direction.upcomingDepartures)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: actionColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    departure,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: actionTextColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
            ],
          )
        else
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: lineColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: lineColor.withValues(alpha: 0.16)),
            ),
            child: Text(
              _emptyStateMessage,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 11.5,
                color: colors.secondaryText,
              ),
            ),
          ),

        const SizedBox(height: 14),

        FilledButton(
          onPressed: onOpenDetails,
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(48),
            backgroundColor: actionColor,
            foregroundColor: actionTextColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: const Row(
            spacing: 8,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.open_in_new_rounded, size: 18),
              Text(
                'Apri linea completa',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
