import 'package:flutter/material.dart';

import '../../../../domain/models/transit_line.dart';
import '../../theme/line_card_colors.dart';
import '../../theme/line_detail_colors.dart';

const _routeAccentColor = LineDetailColors.routeAccent;

/// Tile che rappresenta una fermata nel dettaglio linea.
///
/// Mostra nome, ruolo nella tratta, orario ufficiale e stato di selezione
/// quando la schermata abilita la scelta di una fermata.
class LineDetailStopTile extends StatelessWidget {
  const LineDetailStopTile({
    super.key,
    required this.stop,
    required this.isFirst,
    required this.isLast,
    required this.isSelected,
    required this.onTap,
    this.colors = LineCardColors.defaultPalette,
  });

  /// Fermata mostrata nella tile.
  final TransitLineStop stop;

  /// Indica se la fermata è la prima della direzione.
  final bool isFirst;

  /// Indica se la fermata è l'ultima della direzione.
  final bool isLast;

  /// Indica se la fermata è selezionata.
  final bool isSelected;

  /// Callback eseguita quando la fermata può essere selezionata.
  final VoidCallback? onTap;

  final LineCardPalette colors;

  @override
  Widget build(BuildContext context) {
    final isTerminal = isFirst || isLast;

    final borderColor = isSelected
        ? _routeAccentColor.withValues(alpha: 0.42)
        : isTerminal
        ? _routeAccentColor.withValues(alpha: 0.28)
        : colors.border;

    final backgroundColor = isSelected
        ? _routeAccentColor.withValues(alpha: 0.06)
        : LineDetailColors.surface;

    const borderRadius = BorderRadius.all(Radius.circular(18));

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: LineDetailColors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: borderRadius,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            curve: Curves.easeOutCubic,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: borderRadius,
              border: Border.all(
                color: borderColor,
                width: isSelected ? 1.4 : 1,
              ),                    
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _StopHeader(
                  stopName: stop.name,
                  isFirst: isFirst,
                  isLast: isLast,
                  isSelected: isSelected,
                  colors: colors,
                ),
                const SizedBox(height: 12),
                _OfficialTimeLine(stop: stop, colors: colors),
                const SizedBox(height: 6),
                Text(
                  'Orario stimato non disponibile',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 10.6,
                    color: colors.secondaryText,
                    height: 1.35,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StopHeader extends StatelessWidget {
  const _StopHeader({
    required this.stopName,
    required this.isFirst,
    required this.isLast,
    required this.isSelected,
    required this.colors,
  });

  final String stopName;
  final bool isFirst;
  final bool isLast;
  final bool isSelected;
  final LineCardPalette colors;

  @override
  Widget build(BuildContext context) {
    final isTerminal = isFirst || isLast;
    final badgeLabel = isFirst
        ? 'Partenza'
        : isLast
        ? 'Capolinea'
        : null;

    return Wrap(
      spacing: 6,
      runSpacing: 6,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          stopName,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: colors.primaryText,
            fontSize: 13.5,
            fontWeight: isTerminal ? FontWeight.w800 : FontWeight.w700,
            height: 1.2,
          ),
        ),
        if (badgeLabel != null)
          _StopBadge(
            label: badgeLabel,
            backgroundColor: _routeAccentColor,
            textColor: LineCardColors.textOn(_routeAccentColor, colors: colors),
          ),
        if (isSelected)
          _StopBadge(
            label: 'Selezionata',
            backgroundColor: _routeAccentColor.withValues(alpha: 0.16),
            textColor: _routeAccentColor,
          ),
      ],
    );
  }
}

class _OfficialTimeLine extends StatelessWidget {
  const _OfficialTimeLine({required this.stop, required this.colors});

  final TransitLineStop stop;
  final LineCardPalette colors;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final labelStyle = textTheme.bodySmall?.copyWith(
      fontSize: 10.6,
      color: colors.secondaryText,
      height: 1.25,
      fontWeight: FontWeight.w500,
    );

    final valueStyle = textTheme.titleMedium?.copyWith(
      fontSize: 12.6,
      color: colors.primaryText,
      height: 1.2,
      fontWeight: FontWeight.w700,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: Text('Orario ufficiale', style: labelStyle)),
        const SizedBox(width: 12),
        Text(
          stop.hasOfficialTime ? stop.officialTime! : '--:--',
          style: valueStyle,
          textAlign: TextAlign.right,
        ),
      ],
    );
  }
}

class _StopBadge extends StatelessWidget {
  const _StopBadge({
    required this.label,
    required this.backgroundColor,
    required this.textColor,
  });

  final String label;
  final Color backgroundColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          fontSize: 9.5,
          color: textColor,
          fontWeight: FontWeight.w800,
          height: 1.1,
        ),
      ),
    );
  }
}
