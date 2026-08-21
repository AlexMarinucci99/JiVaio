import 'package:flutter/material.dart';

/// Palette usata dalle card della feature linee.
///
/// Centralizza i colori specifici delle card.
class LineCardPalette {
  const LineCardPalette({
    this.listAccent = const Color.fromARGB(255, 7, 74, 197),
    this.surface = Colors.white,
    this.border = const Color(0xFFE5EAF2),
    this.primaryText = const Color(0xFF191970),
    this.secondaryText = const Color(0xFF5D6675),
    this.mutedText = const Color(0xFF8A94A6),
    this.directionButtonBackground = const Color.fromARGB(31, 241, 3, 15),
    this.directionButtonForeground = const Color(0xFF2F80ED),
    this.directionButtonDisabledForeground = const Color(0xFF8A94A6),
    this.pillBackground = const Color(0xFFF5F7FB),
    this.savedHeart = const Color(0xFFEF4444),
    this.labelAccent = const Color(0xFF2F80ED),
  });

  /// Colore uniforme degli elementi principali nelle card dell'elenco linee.
  final Color listAccent;

  /// Colore sfondo card.
  final Color surface;

  final Color border;

  final Color primaryText;

  final Color secondaryText;

  final Color mutedText;

  final Color directionButtonBackground;

  final Color directionButtonForeground;

  final Color directionButtonDisabledForeground;

  final Color pillBackground;

  final Color savedHeart;

  final Color labelAccent;
}

/// Fornisce colori e stili condivisi per le card delle linee.

class LineCardColors {
  const LineCardColors._();

  /// Palette predefinita condivisa dalla feature linee.
  static const LineCardPalette defaultPalette = LineCardPalette();

  /// Restituisce un colore di testo leggibile su [backgroundColor].
  static Color textOn(
    Color backgroundColor, {
    required LineCardPalette colors,
  }) {
    return backgroundColor.computeLuminance() > 0.58
        ? colors.primaryText
        : Colors.white;
  }

  /// Restituisce la decorazione standard della card linea.
  static BoxDecoration cardDecoration({required LineCardPalette colors}) {
    return BoxDecoration(
      color: colors.surface,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: colors.border),
    );
  }
}
