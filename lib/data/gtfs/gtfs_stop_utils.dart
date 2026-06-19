import 'gtfs_collection_utils.dart';
import 'gtfs_utils.dart';

/// Restituisce il nome normalizzato di una fermata GTFS.
String gtfsStopName(GtfsRawMap? stop) {
  if (stop == null) {
    return 'Fermata non disponibile';
  }

  final name = gtfsStringValue(stop, 'stop_name');

  if (name.isEmpty) {
    return 'Fermata non disponibile';
  }

  return gtfsNormalizeStopName(name);
}

/// Normalizza il nome di una fermata GTFS.
String gtfsNormalizeStopName(String value) {
  final lower = value.toLowerCase();

  if (lower.isEmpty) {
    return value;
  }

  return lower
      .split(' ')
      .where((part) => part.trim().isNotEmpty)
      .map((part) {
        if (part.length == 1) {
          return part.toUpperCase();
        }

        return part[0].toUpperCase() + part.substring(1);
      })
      .join(' ');
}
