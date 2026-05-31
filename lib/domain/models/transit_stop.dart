class TransitStop {
  const TransitStop({
    required this.stopId,
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  // Identificativo GTFS della fermata.
  final String stopId;

  // Nome leggibile della fermata.
  final String name;

  // Coordinate GTFS lette direttamente dal file raw.
  final double latitude;
  final double longitude;
}
