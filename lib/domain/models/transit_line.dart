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
  // Esempio GTFS: route_id.
  final String routeId;

  // Numero/nome breve mostrato nel badge.
  // Esempio: "1", "2U", "6D".
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
    const knownUnidirectionalShortNames = <String>{'2U', '2UT'};

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
  // Esempio: "outbound", "return", oppure direction_id GTFS.
  final String key;

  // Capolinea di partenza.
  final String originName;

  // Capolinea di arrivo.
  final String destinationName;

  // Numero fermate della direzione.
  final int stopCount;

  // Prossime partenze già formattate.
  // Verranno alimentate da raw/service/repository.
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

class TransitLineDirectionSchedule {
  const TransitLineDirectionSchedule({
    required this.routeId,
    required this.directionKey,
    required this.timeRangeLabel,
    required this.departures,
    required this.stops,
    this.selectedTripId,
    this.hasServiceToday = true,
  });

  // Linea a cui appartiene lo schedule.
  final String routeId;

  // Direzione selezionata.
  final String directionKey;

  // Fascia oraria mostrata nella card partenze.
  // Esempio: "18:00 - 19:00".
  final String timeRangeLabel;

  // Corse disponibili nella fascia.
  final List<TransitLineDeparture> departures;

  // Fermate ordinate della direzione, possibilmente con orario ufficiale
  // riferito alla corsa selezionata.
  final List<TransitLineStop> stops;

  // Trip selezionato nella fascia. Può essere null se non ci sono corse.
  final String? selectedTripId;

  // Indica se la linea ha servizio nella giornata.
  final bool hasServiceToday;

  bool get hasDepartures => departures.isNotEmpty;

  bool get hasStops => stops.isNotEmpty;

  String get emptyDeparturesMessage {
    if (!hasServiceToday) {
      return 'Nessuna corsa attiva per oggi.';
    }

    return 'Non ci sono bus in questa fascia oraria.';
  }
}

class TransitLineDeparture {
  const TransitLineDeparture({
    required this.tripId,
    required this.departureTime,
  });

  // Identificativo della corsa.
  // Esempio GTFS: trip_id.
  final String tripId;

  // Orario ufficiale della partenza dal capolinea.
  // Per ora stringa formattata "HH:mm", così la UI resta semplice.
  final String departureTime;
}

class TransitLineStop {
  const TransitLineStop({
    required this.stopId,
    required this.name,
    required this.sequence,
    this.officialTime,
  });

  // Identificativo fermata.
  // Esempio GTFS: stop_id.
  final String stopId;

  // Nome fermata mostrato nella timeline.
  final String name;

  // Ordine della fermata nella direzione.
  final int sequence;

  // Orario ufficiale della fermata per la corsa selezionata.
  // Può essere null se non disponibile.
  final String? officialTime;

  bool get hasOfficialTime {
    final value = officialTime;
    return value != null && value.trim().isNotEmpty;
  }
}
