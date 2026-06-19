import '../../domain/models/transit_line.dart';
import 'gtfs_collection_utils.dart';
import 'gtfs_trip_utils.dart';
import 'gtfs_utils.dart';

/// Restituisce le partenze GTFS comprese tra [startMinutes] ed [endMinutes].
List<TransitLineDeparture> gtfsDeparturesForRange({
  required List<GtfsRawMap> trips,
  required Map<String, List<GtfsRawMap>> stopTimesByTrip,
  required int startMinutes,
  required int endMinutes,
}) {
  final departures = <TransitLineDeparture>[];

  for (final trip in trips) {
    final tripId = gtfsStringValue(trip, 'trip_id');
    final stopTimes = stopTimesByTrip[tripId] ?? const <GtfsRawMap>[];

    if (stopTimes.isEmpty) {
      continue;
    }

    final departureTime = gtfsStringValue(stopTimes.first, 'departure_time');
    final departureMinutes = gtfsTimeToMinutes(departureTime);

    if (departureMinutes >= startMinutes && departureMinutes < endMinutes) {
      departures.add(
        TransitLineDeparture(
          tripId: tripId,
          departureTime: gtfsFormatTime(departureTime),
        ),
      );
    }
  }

  departures.sort((a, b) {
    return gtfsTimeToMinutes(
      a.departureTime,
    ).compareTo(gtfsTimeToMinutes(b.departureTime));
  });

  return departures;
}

/// Restituisce le prossime partenze GTFS successive a [moment].
List<String> gtfsUpcomingDepartures({
  required List<GtfsRawMap> trips,
  required Map<String, List<GtfsRawMap>> stopTimesByTrip,
  required DateTime moment,
  required int limit,
}) {
  final nowMinutes = moment.hour * 60 + moment.minute;
  final departures = <String>[];

  final sortedTrips = [...trips]
    ..sort((a, b) {
      final aTime = gtfsFirstDepartureMinutes(a, stopTimesByTrip);
      final bTime = gtfsFirstDepartureMinutes(b, stopTimesByTrip);
      return aTime.compareTo(bTime);
    });

  for (final trip in sortedTrips) {
    final tripId = gtfsStringValue(trip, 'trip_id');
    final stopTimes = stopTimesByTrip[tripId] ?? const <GtfsRawMap>[];

    if (stopTimes.isEmpty) {
      continue;
    }

    final departureTime = gtfsStringValue(stopTimes.first, 'departure_time');
    final departureMinutes = gtfsTimeToMinutes(departureTime);

    if (departureMinutes < nowMinutes) {
      continue;
    }

    departures.add(gtfsFormatTime(departureTime));

    if (departures.length == limit) {
      break;
    }
  }

  return departures;
}
