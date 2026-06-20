import 'package:flutter/material.dart';

import '../../../../domain/models/transit_line.dart';
import '../../theme/line_card_colors.dart';

/// Tile che rappresenta una fermata nel dettaglio linea.
///
/// Mostra nome, ruolo nella tratta, orario ufficiale e stato di selezione
/// quando la schermata abilita la scelta di una fermata.
class LineDetailStopTile extends StatelessWidget {
  const LineDetailStopTile({
    super.key,
    required this.stop,
    required this.lineColor,
    required this.isFirst,
    required this.isLast,
    required this.isSelected,
    required this.isSelectionEnabled,
    required this.onTap,
    this.colors = LineCardColors.defaultPalette,
  });

  /// Fermata mostrata nella tile.
  final TransitLineStop stop;

  final Color lineColor;

  /// Indica se la fermata è la prima della direzione
  final bool isFirst;

  /// ultima in direzione
  final bool isLast;

  ///se è selezionata
  final bool isSelected;

  /// Indica se la tile può essere selezionata.
  final bool isSelectionEnabled;

  /// Callback eseguita quando l'utente seleziona la fermata.
  final VoidCallback onTap;

  final LineCardPalette colors;

  @override
  Widget build(BuildContext context) {
    final borderColor = isSelected
        ? lineColor.withValues(alpha: 0.42)
        : _terminalBorderColor();

    final backgroundColor = isSelected
        ? lineColor.withValues(alpha: 0.06)
        : Colors.white;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isSelectionEnabled ? onTap : null,
          borderRadius: BorderRadius.circular(18),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            curve: Curves.easeOutCubic,
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: borderColor,
                width: isSelected ? 1.4 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: colors.shadowBase.withValues(alpha: 0.045),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _StopHeader(
                  stopName: stop.name,
                  isFirst: isFirst,
                  isLast: isLast,
                  isSelected: isSelected,
                  lineColor: lineColor,
                  colors: colors,
                ),
                const SizedBox(height: 12),
                _OfficialTimeLine(
                  officialTime: stop.officialTime,
                  colors: colors,
                ),
                const SizedBox(height: 6),
                _EstimatedTimeUnavailable(colors: colors),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _terminalBorderColor() {
    if (isFirst || isLast) {
      return lineColor.withValues(alpha: 0.28);
    }

    return colors.border;
  }
}

class _StopHeader extends StatelessWidget {
  const _StopHeader({
    required this.stopName,
    required this.isFirst,
    required this.isLast,
    required this.isSelected,
    required this.lineColor,
    required this.colors,
  });

  final String stopName;
  final bool isFirst;
  final bool isLast;
  final bool isSelected;
  final Color lineColor;
  final LineCardPalette colors;

  @override
  Widget build(BuildContext context) {
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
            fontWeight: isFirst || isLast ? FontWeight.w800 : FontWeight.w700,
            height: 1.2,
          ),
        ),
        if (badgeLabel != null)
          _StopBadge(
            label: badgeLabel,
            backgroundColor: lineColor,
            textColor: LineCardColors.textOn(lineColor, colors: colors),
          ),
        if (isSelected)
          _StopBadge(
            label: 'Selezionata',
            backgroundColor: lineColor.withValues(alpha: 0.16),
            textColor: lineColor,
          ),
      ],
    );
  }
}

class _OfficialTimeLine extends StatelessWidget {
  const _OfficialTimeLine({required this.officialTime, required this.colors});

  final String? officialTime;
  final LineCardPalette colors;

  @override
  Widget build(BuildContext context) {
    final labelStyle = Theme.of(context).textTheme.bodySmall?.copyWith(
      fontSize: 10.6,
      color: colors.secondaryText,
      height: 1.25,
      fontWeight: FontWeight.w500,
    );

    final valueStyle = Theme.of(context).textTheme.titleMedium?.copyWith(
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
          _displayOfficialTime,
          style: valueStyle,
          textAlign: TextAlign.right,
        ),
      ],
    );
  }

  String get _displayOfficialTime {
    final value = officialTime;

    if (value == null || value.trim().isEmpty) {
      return '--:--';
    }

    return value;
  }
}

class _EstimatedTimeUnavailable extends StatelessWidget {
  const _EstimatedTimeUnavailable({required this.colors});

  final LineCardPalette colors;

  @override
  Widget build(BuildContext context) {
    return Text(
      'Orario stimato non disponibile',
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
        fontSize: 10.6,
        color: colors.secondaryText,
        height: 1.35,
        fontWeight: FontWeight.w500,
      ),
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
