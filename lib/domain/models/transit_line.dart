///linea del trasporto urbano.
class TransitLine {
  const TransitLine({
    required this.routeId,
    required this.shortName,
    required this.displayName,
    required this.directions,
  });

  final String routeId;

  /// Nome breve mostrato nei badge e nelle card.
  final String shortName;

  /// Nome principale mostrato all'utente.
  final String displayName;
  final List<TransitLineDirection> directions;

  /// Indica se la linea viene trattata come monodirezionale.
  bool get isUnidirectional =>
      const {'2U', '2UT'}.contains(shortName.trim().toUpperCase());
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

  final String key;
  final String originName;
  final String destinationName;

  /// Numero di fermate nella direzione.
  final int stopCount;

  /// Prossime partenze.
  final List<String> upcomingDepartures;

  /// Indica se la direzione ha servizio nella giornata corrente.
  final bool hasServiceToday;

  bool get hasUpcomingDepartures => upcomingDepartures.isNotEmpty;
}

/// Raccoglie orari e fermate per una specifica direzione.
class TransitLineDirectionSchedule {
  const TransitLineDirectionSchedule({
    required this.departures,
    required this.stops,
  });

  /// Corse disponibili nella fascia oraria.
  final List<TransitLineDeparture> departures;

  /// Fermate ordinate della direzione.
  final List<TransitLineStop> stops;
}

/// Descrive una corsa disponibile per una linea.
class TransitLineDeparture {
  const TransitLineDeparture({
    required this.tripId,
    required this.departureTime,
  });

  final String tripId;

  /// Orario ufficiale di partenza dal capolinea.
  final String departureTime;
}

/// Descrive una fermata ordinata all'interno di una direzione.
class TransitLineStop {
  const TransitLineStop({
    required this.stopId,
    required this.name,
    this.officialTime,
  });

  final String stopId;
  final String name;
  final String? officialTime;

  bool get hasOfficialTime => officialTime?.trim().isNotEmpty ?? false;
}
