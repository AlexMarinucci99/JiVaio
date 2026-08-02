/// Rappresenta una fermata del trasporto urbano visualizzabile sulla mappa.
class TransitStop {
  const TransitStop({
    required this.stopId,
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  final String stopId;
  final String name;
  final double latitude;
  final double longitude;
}
