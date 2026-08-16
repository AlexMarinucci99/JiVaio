import 'package:flutter/material.dart';

import 'line_card_colors.dart';

/// Definisce i colori specifici della schermata di dettaglio linea.
class LineDetailColors {
  const LineDetailColors._();

  static const Color pageBackground = Color(0xFFF6FAFF);
  static const Color surface = Colors.white;
  static const Color softSurface = Color(0xFFF3F6FB);
  static const Color transparent = Colors.transparent;

  static const Color successSurface = Color(0xFFEFFAF4);
  static const Color successText = Color(0xFF047857);

  static const Color warningSurface = Color(0xFFFFF7ED);
  static const Color emptyDeparturesText = Color.fromARGB(255, 56, 4, 139);
  static const Color emptyRouteText = Color.fromARGB(255, 4, 11, 117);
  static const Color reportInstructionWarningText = Color(0xFF2B0681);

  static const Color disabledSurface = Color(0xFFF4F6FA);
  static const Color disabledText = Color(0xFF9AA3B2);

  static const Color timeFilterAccent = Color(0xFF2F7DF6);
  static const Color reportAccent = Color(0xFF2F7DF6);
  static const Color routeAccent = Color(0xFF2F7DF6);
  static const Color onAccent = Colors.white;
}

extension LineDetailTextStyles on TextTheme {
  TextStyle? lineDetailCardTitle(LineCardPalette colors) =>
      titleMedium?.copyWith(
        color: colors.primaryText,
        fontSize: 13,
        fontWeight: FontWeight.w800,
      );

  TextStyle? lineDetailCardDescription(LineCardPalette colors) =>
      bodySmall?.copyWith(
        color: colors.secondaryText,
        fontSize: 12,
        height: 1.35,
        fontWeight: FontWeight.w500,
      );
}
