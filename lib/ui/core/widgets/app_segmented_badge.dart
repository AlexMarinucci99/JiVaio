import 'package:flutter/material.dart';

/// Badge compatto mostrato all'interno del controllo segmentato.
class AppSegmentedBadge extends StatelessWidget {
  const AppSegmentedBadge({
    super.key,
    required this.label,
    required this.backgroundColor,
    required this.textColor,
  });

  /// Testo mostrato nel badge.
  final String label;

  /// Colore dello sfondo.
  final Color backgroundColor;

  /// Colore del testo.
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
      padding: const EdgeInsets.symmetric(horizontal: 7),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w800,
          height: 1,
        ),
      ),
    );
  }
}
