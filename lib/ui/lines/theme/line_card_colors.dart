import 'package:flutter/material.dart';

/// Palette usata dalle card della feature linee.
///
/// Centralizza i colori specifici delle card, evitando che i widget
/// definiscano direttamente valori cromatici nel layout.
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
    this.shadowBase = const Color(0xFF0F172A),
  });

  /// Colore uniforme degli elementi principali nelle card dell'elenco linee.
  final Color listAccent;

  /// Colore sfondo card.
  final Color surface;

  /// Colore bordi.
  final Color border;

  /// Colore testo principale.
  final Color primaryText;

  /// Colore testo secondario.
  final Color secondaryText;

  /// Colore testo meno importante.
  final Color mutedText;

  /// Sfondo del controllo per il cambio di direzione.
  final Color directionButtonBackground;

  /// Colore dell'icona quando il controllo è evidenziato.
  final Color directionButtonForeground;

  /// Colore dell'icona quando lo swap non è disponibile.
  final Color directionButtonDisabledForeground;

  /// Sfondo delle pill informative.
  final Color pillBackground;

  /// Colore cuore quando la linea è salvata.
  final Color savedHeart;

  /// Colore label "Partenza" / "Capolinea".
  final Color labelAccent;

  /// Colore base ombra.
  final Color shadowBase;
}

/// Utility cromatiche condivise dai widget della feature linee.
///
/// Espone la palette predefinita e alcune funzioni per convertire
/// i colori GTFS in valori utilizzabili dalla UI.
class LineCardColors {
  const LineCardColors._();

  /// Palette predefinita condivisa dalla feature linee.
  static const LineCardPalette defaultPalette = LineCardPalette();

  /// Restituisce un colore di testo leggibile su [backgroundColor].
  static Color textOn(Color backgroundColor, {LineCardPalette? colors}) {
    final palette = colors ?? defaultPalette;

    return backgroundColor.computeLuminance() > 0.58
        ? palette.primaryText
        : Colors.white;
  }

  /// Restituisce la decorazione standard della card linea.
  static BoxDecoration cardDecoration({LineCardPalette? colors}) {
    final palette = colors ?? defaultPalette;

    return BoxDecoration(
      color: palette.surface,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: palette.border),
    );
  }
}
