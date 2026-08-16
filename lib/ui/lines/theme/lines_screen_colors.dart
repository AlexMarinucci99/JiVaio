import 'package:flutter/material.dart';

import '../../core/themes/app_segmented_control_colors.dart';

/// Palette cromatica della schermata che mostra l'elenco delle linee.
///
/// Comprende lo sfondo della pagina, i testi dell'intestazione,
/// il selettore "Tutte / Salvate" e le card degli stati vuoto o di errore.
///
/// I colori delle singole card delle linee sono invece definiti
/// separatamente in `line_card_colors.dart`.
class LinesScreenColors {
  const LinesScreenColors({
    this.pageBackground = const Color(0xFFF6FAFF),
    this.gradientStart = const Color(0xFFF6FAFF),
    this.gradientEnd = const Color(0xFFF2F6FC),
    this.primaryText = const Color(0xFF111827),
    this.secondaryText = const Color(0xFF5D6675),
    this.stateCardBackground = Colors.white,
    this.stateCardBorder = const Color(0xFFE5EAF2),
    this.segmentedControlColors = const AppSegmentedControlColors(),
  });

  /// Colore di base dello Scaffold.
  final Color pageBackground;

  /// Colori del gradiente verticale della pagina.
  final Color gradientStart;
  final Color gradientEnd;

  /// Colori dei testi della schermata e dei messaggi di stato.
  final Color primaryText;
  final Color secondaryText;

  /// Colori delle card mostrate negli stati vuoto o di errore.
  final Color stateCardBackground;
  final Color stateCardBorder;

  /// Palette del selettore tra tutte le linee e quelle salvate.
  final AppSegmentedControlColors segmentedControlColors;
}
