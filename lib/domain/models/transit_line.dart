/// Rappresenta una linea del trasporto urbano.
class TransitLine {
  const TransitLine({
    required this.routeId,
    required this.shortName,
    required this.displayName,
    required this.routeLongName,
    required this.routeColor,
    required this.directions,
  });

  /// Identificativo della linea nella sorgente dati.
  final String routeId;

  /// Nome breve mostrato nei badge e nelle card.
  final String shortName;

  /// Nome principale mostrato all'utente.
  final String displayName;

  /// Descrizione estesa della linea.
  final String routeLongName;

  /// Colore associato alla linea in formato esadecimale.
  final String routeColor;

  /// Direzioni disponibili per la linea.
  final List<TransitLineDirection> directions;

  TransitLineDirection get primaryDirection => directions.first;

  /// Indica se la linea viene trattata come monodirezionale nel prototipo.
  bool get isUnidirectional {
    const knownUnidirectionalShortNames = <String>{'2U', '2UT'};

    return knownUnidirectionalShortNames.contains(
      shortName.trim().toUpperCase(),
    );
  }
}

/// Descrive una direzione di percorrenza associata a una linea.
class TransitLineDirection {
  const TransitLineDirection({
    required this.key,
    required this.originName,
    required this.destinationName,
    required this.stopCount,
    required this.upcomingDepartures,
    this.hasServiceToday = true,
  });

  /// Chiave interna della direzione.
  final String key;

  /// Capolinea di partenza.
  final String originName;

  /// Capolinea di arrivo.
  final String destinationName;

  /// Numero di fermate nella direzione.
  final int stopCount;

  /// Prossime partenze già formattate per la UI.
  final List<String> upcomingDepartures;

  /// Indica se la direzione ha servizio nella giornata corrente.
  final bool hasServiceToday;

  bool get hasUpcomingDepartures => upcomingDepartures.isNotEmpty;

  /// Restituisce il messaggio da mostrare quando non ci sono partenze.
  String get emptyStateMessage {
    if (!hasServiceToday) {
      return 'Nessuna corsa attiva per oggi.';
    }

    return 'Nessuna altra partenza disponibile per oggi.';
  }
}

/// Raccoglie orari e fermate per una specifica direzione.
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

  /// Identificativo della linea associata allo schedule.
  final String routeId;

  /// Chiave della direzione selezionata.
  final String directionKey;

  /// Fascia oraria mostrata nella sezione partenze.
  final String timeRangeLabel;

  /// Corse disponibili nella fascia oraria.
  final List<TransitLineDeparture> departures;

  /// Fermate ordinate della direzione.
  final List<TransitLineStop> stops;

  /// Identificativo della corsa selezionata, se disponibile.
  final String? selectedTripId;

  /// Indica se la linea ha servizio nella giornata corrente.
  final bool hasServiceToday;

  bool get hasDepartures => departures.isNotEmpty;

  bool get hasStops => stops.isNotEmpty;

  /// Restituisce il messaggio da mostrare quando non ci sono corse.
  String get emptyDeparturesMessage {
    if (!hasServiceToday) {
      return 'Nessuna corsa attiva per oggi.';
    }

    return 'Non ci sono bus in questa fascia oraria.';
  }
}

/// Descrive una corsa disponibile per una linea.
class TransitLineDeparture {
  const TransitLineDeparture({
    required this.tripId,
    required this.departureTime,
  });

  /// Identificativo della corsa nella sorgente dati.
  final String tripId;

  /// Orario ufficiale di partenza dal capolinea.
  final String departureTime;
}

/// Descrive una fermata ordinata all'interno di una direzione.
class TransitLineStop {
  const TransitLineStop({
    required this.stopId,
    required this.name,
    required this.sequence,
    this.officialTime,
  });

  /// Identificativo della fermata nella sorgente dati.
  final String stopId;

  /// Nome della fermata mostrato nella timeline.
  final String name;

  /// Posizione della fermata nella sequenza della direzione.
  final int sequence;

  /// Orario ufficiale della fermata per la corsa selezionata.
  final String? officialTime;

  bool get hasOfficialTime {
    final value = officialTime;
    return value != null && value.trim().isNotEmpty;
  }
}
