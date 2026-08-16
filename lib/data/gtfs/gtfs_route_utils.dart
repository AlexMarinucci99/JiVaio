/// Costruisce il sottotitolo descrittivo di una route GTFS.
String gtfsRouteSubtitle({
  required String shortName,
  required String routeDescription,
}) {
  final normalizedShortName = shortName.trim();
  final normalizedDescription = routeDescription.trim();

  if (normalizedDescription.isEmpty) {
    return normalizedShortName.isEmpty
        ? 'Trasporto urbano'
        : 'Linea $normalizedShortName';
  }

  return normalizedShortName.isEmpty
      ? normalizedDescription
      : 'Linea $normalizedShortName · $normalizedDescription';
}
