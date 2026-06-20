/// Tipologia di passaggio mostrato nella timeline del percorso consigliato.
enum RouteStepType { departure, walk, wait, bus, destination }

/// Risultato completo della pianificazione di un percorso.
///
/// Il modello non dipende da Flutter e può essere utilizzato sia dalla UI
/// sia da una futura implementazione dell'algoritmo di ricerca.
class RouteResult {
  RouteResult({
    required String origin,
    required String destination,
    required this.totalDuration,
    required List<String> nextBusTimes,
    required List<RouteStep> recommendedSteps,
    required List<AlternativeRoute> alternativeRoutes,
  }) : assert(origin.trim().isNotEmpty),
       assert(destination.trim().isNotEmpty),
       assert(!totalDuration.isNegative),
       assert(recommendedSteps.isNotEmpty),
       origin = origin.trim(),
       destination = destination.trim(),
       nextBusTimes = List<String>.unmodifiable(nextBusTimes),
       recommendedSteps = List<RouteStep>.unmodifiable(recommendedSteps),
       alternativeRoutes = List<AlternativeRoute>.unmodifiable(
         alternativeRoutes,
       );

  /// Punto di partenza normalizzato del percorso.
  final String origin;

  /// Destinazione normalizzata del percorso.
  final String destination;

  /// Durata complessiva stimata del percorso.
  final Duration totalDuration;

  /// Orari delle prossime navette utili alla fermata iniziale.
  ///
  /// In questa fase sono stringhe già formattate. Con l'algoritmo reale
  /// potranno essere sostituite da valori temporali o da un mapper dedicato.
  final List<String> nextBusTimes;

  /// Passaggi ordinati del percorso consigliato.
  final List<RouteStep> recommendedSteps;

  /// Percorsi alternativi rispetto alla soluzione consigliata.
  final List<AlternativeRoute> alternativeRoutes;
}

/// Singolo passaggio della timeline del percorso consigliato.
class RouteStep {
  const RouteStep({
    required this.type,
    required this.title,
    this.subtitle,
    this.duration,
    this.scheduledTime,
    this.estimatedTime,
    this.lineCode,
  }) : assert(title != '');

  /// Tipologia del passaggio.
  final RouteStepType type;

  /// Titolo mostrato nella timeline.
  final String title;

  /// Descrizione opzionale del passaggio.
  final String? subtitle;

  /// Durata del passaggio, quando rilevante.
  final Duration? duration;

  /// Orario ufficiale o previsto del passaggio.
  ///
  /// In questa fase rimane una stringa già formattata in formato "HH:mm".
  final String? scheduledTime;

  /// Orario stimato in tempo reale.
  ///
  /// Rimane null finché il realtime non viene implementato.
  final String? estimatedTime;

  /// Codice della linea utilizzata nel passaggio.
  final String? lineCode;
}

/// Percorso alternativo rispetto alla soluzione consigliata.
class AlternativeRoute {
  const AlternativeRoute({
    required this.lineCode,
    required this.description,
    required this.duration,
    required this.departureTime,
    required this.arrivalTime,
  }) : assert(lineCode != ''),
       assert(description != '');

  /// Codice della linea proposta come alternativa.
  final String lineCode;

  /// Descrizione sintetica del percorso alternativo.
  final String description;

  /// Durata stimata del percorso alternativo.
  final Duration duration;

  /// Orario di partenza già formattato.
  final String departureTime;

  /// Orario di arrivo già formattato.
  final String arrivalTime;
}
