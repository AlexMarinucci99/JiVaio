import 'package:flutter/material.dart';

/// Palette usata dalle card della feature linee.
///
/// Centralizza i colori specifici delle card, evitando che i widget
/// definiscano direttamente valori cromatici nel layout.
class LineCardPalette {
  const LineCardPalette({
    this.defaultLineColor = const Color(0xFF2F80ED),
    this.listAccent = const Color.fromARGB(255, 7, 74, 197),
    this.surface = Colors.white,
    this.border = const Color(0xFFE5EAF2),
    this.primaryText = const Color(0xFF191970),
    this.secondaryText = const Color(0xFF5D6675),
    this.mutedText = const Color(0xFF8A94A6),
    this.pillBackground = const Color(0xFFF5F7FB),
    this.savedHeart = const Color(0xFFEF4444),
    this.labelAccent = const Color(0xFF2F80ED),
    this.shadowBase = const Color(0xFF0F172A),
  });

  /// Colore linea di fallback quando il valore GTFS non è valido.
  final Color defaultLineColor;

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

  ///Palette predefinita delle card linee.
  ///Master da modificare in futuro.
  static const LineCardPalette defaultPalette = LineCardPalette();

  /// Compatibilità con il codice già esistente.
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

  /// Converte un colore GTFS esadecimale in un [Color] Flutter.
  ///
  /// Se il valore non è valido, restituisce il colore di fallback
  /// definito nella palette.
  static Color parseLineColor(String value, {LineCardPalette? colors}) {
    final palette = colors ?? defaultPalette;
    final normalized = value.replaceAll('#', '').trim();

    if (normalized.length != 6) {
      return palette.defaultLineColor;
    }

    try {
      return Color(int.parse('FF$normalized', radix: 16));
    } catch (_) {
      return palette.defaultLineColor;
    }
  }

  ///Restituisce un colore di testo leggibile su [backgroundColor].
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
      boxShadow: [
        BoxShadow(
          color: palette.shadowBase.withValues(alpha: 0.06),
          blurRadius: 22,
          offset: const Offset(0, 8),
        ),
      ],
    );
  }
}
