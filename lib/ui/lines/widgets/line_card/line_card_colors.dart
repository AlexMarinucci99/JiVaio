import 'package:flutter/material.dart';

class LineCardColors {
  const LineCardColors._();

  static const Color defaultLineColor = Color(0xFF2F80ED);

  static const Color surface = Colors.white;
  static const Color border = Color(0xFFE5EAF2);

  static const Color primaryText = Color(0xFF111827);
  static const Color secondaryText = Color(0xFF5D6675);
  static const Color mutedText = Color(0xFF8A94A6);

  static const Color pillBackground = Color(0xFFF5F7FB);
  static const Color savedHeart = Color(0xFFEF4444);
  static const Color labelAccent = Color(0xFF2F80ED);

  static const Color shadowBase = Color(0xFF0F172A);

  static Color parseLineColor(String value) {
    final normalized = value.replaceAll('#', '').trim();

    if (normalized.length != 6) {
      return defaultLineColor;
    }

    try {
      return Color(int.parse('FF$normalized', radix: 16));
    } catch (_) {
      return defaultLineColor;
    }
  }
  //
  static Color textOn(Color backgroundColor) {
    return backgroundColor.computeLuminance() > 0.58
        ? primaryText
        : Colors.white;
  }

  static BoxDecoration cardDecoration() {
    return BoxDecoration(
      color: surface,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: border),
      boxShadow: [
        BoxShadow(
          color: shadowBase.withValues(alpha: 0.06),
          blurRadius: 22,
          offset: const Offset(0, 8),
        ),
      ],
    );
  }
}
