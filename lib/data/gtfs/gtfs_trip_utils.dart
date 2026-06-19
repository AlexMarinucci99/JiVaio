import 'gtfs_collection_utils.dart';
import 'gtfs_utils.dart';

/// Restituisce la chiave di direzione associata a una corsa GTFS.
String gtfsDirectionKeyOf(GtfsRawMap trip) {
  final directionId = gtfsStringValue(trip, 'direction_id');
  return directionId.isEmpty ? '0' : directionId;
}

/// Restituisce i minuti della prima partenza associata a [trip].
///
/// Il valore alto di fallback mantiene in fondo le corse prive di orari.
int gtfsFirstDepartureMinutes(
  GtfsRawMap trip,
  Map<String, List<GtfsRawMap>> stopTimesByTrip,
) {
  final tripId = gtfsStringValue(trip, 'trip_id');
  final stopTimes = stopTimesByTrip[tripId] ?? const <GtfsRawMap>[];

  if (stopTimes.isEmpty) {
    return 1 << 30;
  }

  return gtfsTimeToMinutes(gtfsStringValue(stopTimes.first, 'departure_time'));
}

/// Restituisce la prima corsa GTFS con fermate disponibili.
///
/// Le corse vengono ordinate in base alla prima partenza disponibile.
GtfsRawMap? gtfsFirstTripWithStops(
  List<GtfsRawMap> trips,
  Map<String, List<GtfsRawMap>> stopTimesByTrip,
) {
  final sortedTrips = [...trips]
    ..sort((a, b) {
      final aTime = gtfsFirstDepartureMinutes(a, stopTimesByTrip);
      final bTime = gtfsFirstDepartureMinutes(b, stopTimesByTrip);
      return aTime.compareTo(bTime);
    });

  for (final trip in sortedTrips) {
    final tripId = gtfsStringValue(trip, 'trip_id');
    final stopTimes = stopTimesByTrip[tripId] ?? const <GtfsRawMap>[];

    if (stopTimes.isNotEmpty) {
      return trip;
    }
  }

  return null;
}

/// Restituisce la corsa GTFS rappresentativa da mostrare nel dettaglio linea.
///
/// Se [selectedTripId] è disponibile, cerca prima la corsa selezionata
/// tra quelle attive. In caso contrario usa la prima corsa con fermate.
GtfsRawMap? gtfsFindRepresentativeTrip({
  required String? selectedTripId,
  required List<GtfsRawMap> activeTrips,
  required List<GtfsRawMap> allTrips,
  required Map<String, List<GtfsRawMap>> stopTimesByTrip,
}) {
  if (selectedTripId != null) {
    for (final trip in activeTrips) {
      if (gtfsStringValue(trip, 'trip_id') == selectedTripId) {
        return trip;
      }
    }
  }

  return gtfsFirstTripWithStops(
    activeTrips.isNotEmpty ? activeTrips : allTrips,
    stopTimesByTrip,
  );
}
