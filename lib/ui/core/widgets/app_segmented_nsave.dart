import 'package:flutter/material.dart';

/// Badge compatto mostrato dentro [AppSegmentedControl].
class AppSegmentedNSave extends StatelessWidget {
  const AppSegmentedNSave({
    super.key,
    required this.label,
    required this.backgroundColor,
    required this.textColor,
  });

  /// Testo mostrato nel badge.
  final String label;

  /// Colore dello sfondo del badge.
  final Color backgroundColor;

  /// Colore del testo del badge.
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
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
