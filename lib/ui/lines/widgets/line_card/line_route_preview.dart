import 'package:flutter/material.dart';

import '../../../../domain/models/transit_line.dart';
import 'line_card_colors.dart';
import 'line_central_label.dart';

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

  final TransitLine line;
  final TransitLineDirection direction;
  final Color lineColor;
  final bool canSwapDirection;
  final VoidCallback onSwapDirection;
  final VoidCallback onOpenDetails;

  // Palette propria della preview percorso.
  final LineCardPalette colors;

  @override
  Widget build(BuildContext context) {
    final textColor = LineCardColors.textOn(
      lineColor,
      colors: colors,
    );

    final supportsDirectionSwap = canSwapDirection && !line.isUnidirectional;
    final showsOneWayDirection = line.isUnidirectional;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Box partenza/capolinea.
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

              // Bottone centrale per invertire direzione.
              Material(
                color: lineColor.withValues(alpha: 0.12),
                shape: const CircleBorder(),
                child: IconButton(
                  visualDensity: VisualDensity.compact,
                  onPressed: supportsDirectionSwap ? onSwapDirection : null,
                  icon: Icon(
                    showsOneWayDirection
                        ? Icons.arrow_forward_rounded
                        : Icons.swap_horiz_rounded,
                    color: supportsDirectionSwap || showsOneWayDirection
                        ? lineColor
                        : colors.mutedText,
                    size: 18,
                  ),
                  tooltip: supportsDirectionSwap
                      ? 'Inverti direzione'
                      : 'Direzione unica',
                ),
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

        // Titolo prossime partenze.
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

        // Lista orari.
        if (direction.hasUpcomingDepartures)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: direction.upcomingDepartures
                .map((departure) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: lineColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      departure,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: textColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  );
                })
                .toList(growable: false),
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
              direction.emptyStateMessage,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 11.5,
                color: colors.secondaryText,
              ),
            ),
          ),

        const SizedBox(height: 14),

        // Bottone apertura schermata interna della linea.
        FilledButton(
          onPressed: onOpenDetails,
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(48),
            backgroundColor: lineColor.withValues(alpha: 0.96),
            foregroundColor: textColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.open_in_new_rounded, size: 18),
              SizedBox(width: 8),
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