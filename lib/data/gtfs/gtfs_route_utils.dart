import 'gtfs_collection_utils.dart';
import 'gtfs_utils.dart';

/// Restituisce il colore associato a una route GTFS.
String gtfsRouteColor(GtfsRawMap route) {
  final rawColor = gtfsStringValue(route, 'route_color');

  if (rawColor.length == 6) {
    return rawColor;
  }

  final shortName = gtfsStringValue(route, 'route_short_name').toUpperCase();

  const fallbackColors = <String, String>{
    '1': 'C86F27',
    '1T': 'C86F27',
    '2U': '2F80ED',
    '2UT': '2F80ED',
    '6D': 'F59E0B',
    '6S': '10B981',
    '15': '8B5CF6',
    'NC': 'EF4444',
    'EST': '0EA5E9',
    'OVEST': '14B8A6',
    'NB': '14213D',
    'M2UF': '6366F1',
  };

  return fallbackColors[shortName] ?? '2F80ED';
}

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
