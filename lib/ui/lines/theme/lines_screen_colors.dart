import 'package:flutter/material.dart';

import '../../core/themes/app_segmented_control_colors.dart';

/// Palette della schermata che mostra l'elenco delle linee.
///
/// Mantiene separati i colori specifici della feature
/// dalla struttura dei widget.
class LinesScreenColors {
  const LinesScreenColors({
    this.pageBackground = const Color(0xFFF6FAFF),
    this.gradientStart = const Color(0xFFF6FAFF),
    this.gradientEnd = const Color(0xFFF2F6FC),
    this.titleText = const Color(0xFF111827),
    this.secondaryText = const Color(0xFF5D6675),
    this.cardBackground = Colors.white,
    this.cardBorder = const Color(0xFFE5EAF2),
    this.cardShadow = const Color(0xFF0F172A),
  });

  final Color pageBackground;

  final Color gradientStart;
  final Color gradientEnd;

  final Color titleText;
  final Color secondaryText;

  final Color cardBackground;
  final Color cardBorder;
  final Color cardShadow;

  final AppSegmentedControlColors segmentedControlColors =
      const AppSegmentedControlColors();
}
