/// Dati essenziali del percorso calcolato.
class RouteResult {
  RouteResult({
    required String origin,
    required String destination,
    required String boardingStopName,
    required String lineCode,
    required this.totalDuration,
    required List<String> nextBusTimes,
    this.departureTime,
    this.arrivalTime,
  }) : assert(origin.trim().isNotEmpty),
       assert(destination.trim().isNotEmpty),
       assert(boardingStopName.trim().isNotEmpty),
       assert(lineCode.trim().isNotEmpty),
       assert(!totalDuration.isNegative),
       origin = origin.trim(),
       destination = destination.trim(),
       boardingStopName = boardingStopName.trim(),
       lineCode = lineCode.trim(),
       nextBusTimes = List.unmodifiable(nextBusTimes);

  final String origin;
  final String destination;
  final String boardingStopName;
  final String lineCode;
  final Duration totalDuration;
  final List<String> nextBusTimes;
  final String? departureTime;
  final String? arrivalTime;
}
