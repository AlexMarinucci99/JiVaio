class TransitLine {
  const TransitLine({
    required this.routeId,
    required this.shortName,
    required this.displayName,
    required this.routeLongName,
    required this.routeColor,
    required this.directions,
  });

  // Identificativo interno della linea.
  final String routeId;

  // Numero/nome breve mostrato nel badge.
  // Esempio: "1", "2U", "R".
  final String shortName;

  // Nome visibile principale della linea.
  final String displayName;

  // Nome esteso o descrizione della linea.
  final String routeLongName;

  // Colore linea in formato esadecimale.
  // Esempio: "2F80ED" oppure "#2F80ED".
  final String routeColor;

  // Direzioni disponibili per questa linea.
  final List<TransitLineDirection> directions;

  TransitLineDirection get primaryDirection => directions.first;

  // Alcune linee possono essere considerate a direzione unica.
  bool get isUnidirectional {
    const knownUnidirectionalShortNames = <String>{'2U'};

    return knownUnidirectionalShortNames.contains(
      shortName.trim().toUpperCase(),
    );
  }
}

class TransitLineDirection {
  const TransitLineDirection({
    required this.key,
    required this.originName,
    required this.destinationName,
    required this.stopCount,
    required this.upcomingDepartures,
    this.hasServiceToday = true,
  });

  // Chiave interna della direzione.
  // Esempio: "outbound", "return".
  final String key;

  // Capolinea di partenza.
  final String originName;

  // Capolinea di arrivo.
  final String destinationName;

  // Numero fermate della direzione.
  final int stopCount;

  // Prossime partenze già formattate.
  // Per ora sono stringhe mock. Più avanti arriveranno da GTFS/database.
  final List<String> upcomingDepartures;

  // Serve per distinguere "nessun servizio oggi" da "nessuna altra corsa".
  final bool hasServiceToday;

  bool get hasUpcomingDepartures => upcomingDepartures.isNotEmpty;

  String get emptyStateMessage {
    if (!hasServiceToday) {
      return 'Nessuna corsa attiva per oggi.';
    }

    return 'Nessuna altra partenza disponibile per oggi.';
  }
}
