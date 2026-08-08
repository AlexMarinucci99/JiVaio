import '../../domain/models/transit_line.dart';
import '../../domain/models/transit_stop.dart';
import '../gtfs/gtfs_calendar_utils.dart';
import '../gtfs/gtfs_collection_utils.dart';
import '../gtfs/gtfs_departure_utils.dart';
import '../gtfs/gtfs_route_utils.dart';
import '../gtfs/gtfs_stop_utils.dart';
import '../gtfs/gtfs_trip_utils.dart';
import '../gtfs/gtfs_utils.dart';
import '../services/transit_raw_service.dart';

typedef _RawMap = GtfsRawMap;

/// Traduce i dati GTFS grezzi nei model di dominio del trasporto urbano.
///
/// Il repository nasconde alla UI e ai ViewModel la struttura dei file GTFS,
/// applicando filtri, ordinamenti e normalizzazioni utili alla consultazione.
class TransitRepository {
  TransitRepository({TransitRawService rawService = const TransitRawService()})
    : _rawService = rawService;

  final TransitRawService _rawService;

  Future<TransitRawBundle>? _bundleFuture;
  List<TransitStop>? _cachedMapStops;

  /// Restituisce le fermate visualizzabili sulla mappa.
  ///
  /// La lista include solo fermate effettive con coordinate valide e viene
  /// memorizzata in cache dopo il primo caricamento.
  Future<List<TransitStop>> getMapStops() async {
    final cachedStops = _cachedMapStops;

    if (cachedStops != null) {
      return cachedStops;
    }

    final bundle = await _loadBundle();

    final addedStopIds = <String>{};
    final mapStops = <TransitStop>[];

    for (final rawStop in bundle.stops) {
      final stopId = gtfsStringValue(rawStop, 'stop_id');
      final latitude = gtfsDoubleValue(rawStop, 'stop_lat');
      final longitude = gtfsDoubleValue(rawStop, 'stop_lon');

      // Nel formato GTFS, location_type = 0 identifica una fermata effettiva.
      final locationType = gtfsIntValue(rawStop, 'location_type');

      if (stopId.isEmpty || latitude == null || longitude == null) {
        continue;
      }

      if (locationType != 0) {
        continue;
      }

      if (latitude < -90 ||
          latitude > 90 ||
          longitude < -180 ||
          longitude > 180) {
        continue;
      }

      // Evita marker duplicati se il dataset contiene righe ripetute.
      if (!addedStopIds.add(stopId)) {
        continue;
      }

      mapStops.add(TransitStop(latitude: latitude, longitude: longitude));
    }

    final result = List<TransitStop>.unmodifiable(mapStops);
    _cachedMapStops = result;

    return result;
  }

  /// Restituisce le linee disponibili nel dataset GTFS.
  ///
  /// Per ogni linea costruisce le direzioni, calcola le prossime partenze
  /// rispetto a [moment] e ordina il risultato in modo leggibile per la UI.
  Future<List<TransitLine>> getLines({DateTime? moment}) async {
    final bundle = await _loadBundle();
    final now = moment ?? DateTime.now();

    final stopTimesByTrip = gtfsGroupStopTimesByTrip(bundle.stopTimes);
    final stopsById = gtfsMapById(bundle.stops, 'stop_id');
    final tripsByRoute = gtfsGroupBy(bundle.trips, 'route_id');

    final lines = <TransitLine>[];

    for (final route in bundle.routes) {
      final routeId = gtfsStringValue(route, 'route_id');
      final routeTrips = tripsByRoute[routeId] ?? const <_RawMap>[];

      if (routeTrips.isEmpty) {
        continue;
      }

      final shortName = gtfsStringValue(route, 'route_short_name');

      final rawDirections = _buildDirections(
        routeTrips: routeTrips,
        bundle: bundle,
        stopTimesByTrip: stopTimesByTrip,
        stopsById: stopsById,
        moment: now,
      );

      final directions = _normalizeDirections(
        shortName: shortName,
        directions: rawDirections,
      );

      if (directions.isEmpty) {
        continue;
      }

      final longName = gtfsStringValue(route, 'route_long_name');
      final routeDescription = gtfsStringValue(route, 'route_desc');

      lines.add(
        TransitLine(
          routeId: routeId,
          shortName: shortName.isEmpty ? routeId : shortName,
          displayName: longName.isEmpty ? 'Linea $shortName' : longName,
          routeLongName: gtfsRouteSubtitle(
            shortName: shortName,
            routeDescription: routeDescription,
          ),
          routeColor: gtfsRouteColor(route),
          directions: directions,
        ),
      );
    }

    lines.sort((a, b) {
      final byNumber = gtfsNaturalLineOrder(
        a.shortName,
      ).compareTo(gtfsNaturalLineOrder(b.shortName));

      if (byNumber != 0) {
        return byNumber;
      }

      return a.shortName.compareTo(b.shortName);
    });

    return lines;
  }

  /// Restituisce orari e fermate per una direzione specifica.
  ///
  /// La fascia oraria è calcolata sull'ora corrente di [moment]. Se non ci sono
  /// partenze nella fascia, viene comunque scelta una corsa rappresentativa
  /// per mostrare la sequenza delle fermate.
  Future<TransitLineDirectionSchedule> getLineDirectionSchedule({
    required TransitLine line,
    required TransitLineDirection direction,
    DateTime? moment,
  }) async {
    final bundle = await _loadBundle();
    final now = moment ?? DateTime.now();

    final stopTimesByTrip = gtfsGroupStopTimesByTrip(bundle.stopTimes);
    final stopsById = gtfsMapById(bundle.stops, 'stop_id');

    final routeTrips = bundle.trips
        .where((trip) {
          return gtfsStringValue(trip, 'route_id') == line.routeId &&
              gtfsDirectionKeyOf(trip) == direction.key;
        })
        .toList(growable: false);

    final activeTrips = routeTrips
        .where((trip) {
          return gtfsIsTripActiveOnDate(
            trip: trip,
            calendar: bundle.calendar,
            calendarDates: bundle.calendarDates,
            date: now,
          );
        })
        .toList(growable: false);

    final rangeStartMinutes = now.hour * 60;
    final rangeEndMinutes = rangeStartMinutes + 60;

    final departures = gtfsDeparturesForRange(
      trips: activeTrips,
      stopTimesByTrip: stopTimesByTrip,
      startMinutes: rangeStartMinutes,
      endMinutes: rangeEndMinutes,
    );

    final selectedTripId = departures.isEmpty ? null : departures.first.tripId;

    final representativeTrip = gtfsFindRepresentativeTrip(
      selectedTripId: selectedTripId,
      activeTrips: activeTrips,
      allTrips: routeTrips,
      stopTimesByTrip: stopTimesByTrip,
    );

    final stops = representativeTrip == null
        ? const <TransitLineStop>[]
        : _buildStopsForTrip(
            trip: representativeTrip,
            stopTimesByTrip: stopTimesByTrip,
            stopsById: stopsById,
            includeOfficialTimes: selectedTripId != null,
          );

    return TransitLineDirectionSchedule(
      timeRangeLabel:
          '${now.hour.toString().padLeft(2, '0')}:00 - '
          '${(now.hour + 1).toString().padLeft(2, '0')}:00',
      departures: departures,
      stops: stops,
      selectedTripId: selectedTripId,
      hasServiceToday: activeTrips.isNotEmpty,
    );
  }

  Future<TransitRawBundle> _loadBundle() async {
    final future = _bundleFuture ??= _rawService.loadBundle();

    try {
      return await future;
    } catch (_) {
      if (identical(_bundleFuture, future)) {
        _bundleFuture = null;
      }

      rethrow;
    }
  }

  List<TransitLineDirection> _normalizeDirections({
    required String shortName,
    required List<TransitLineDirection> directions,
  }) {
    if (directions.isEmpty) {
      return directions;
    }

    final normalizedShortName = shortName.trim().toUpperCase();

    if (normalizedShortName != '2UT') {
      return directions;
    }

    final terminalDirection = directions.firstWhere((direction) {
      return direction.destinationName.trim().toLowerCase().contains(
        'terminal',
      );
    }, orElse: () => directions.first);

    return <TransitLineDirection>[
      TransitLineDirection(
        key: terminalDirection.key,
        originName: "L'aquilone",
        destinationName: 'Terminal',
        stopCount: terminalDirection.stopCount,
        upcomingDepartures: terminalDirection.upcomingDepartures,
        hasServiceToday: terminalDirection.hasServiceToday,
      ),
    ];
  }

  List<TransitLineDirection> _buildDirections({
    required List<_RawMap> routeTrips,
    required TransitRawBundle bundle,
    required Map<String, List<_RawMap>> stopTimesByTrip,
    required Map<String, _RawMap> stopsById,
    required DateTime moment,
  }) {
    final directionKeys =
        routeTrips.map(gtfsDirectionKeyOf).toSet().toList(growable: false)
          ..sort();

    final directions = <TransitLineDirection>[];

    for (final directionKey in directionKeys) {
      final allDirectionTrips = routeTrips
          .where((trip) {
            return gtfsDirectionKeyOf(trip) == directionKey;
          })
          .toList(growable: false);

      final activeDirectionTrips = allDirectionTrips
          .where((trip) {
            return gtfsIsTripActiveOnDate(
              trip: trip,
              calendar: bundle.calendar,
              calendarDates: bundle.calendarDates,
              date: moment,
            );
          })
          .toList(growable: false);

      final representativeTrip = gtfsFirstTripWithStops(
        activeDirectionTrips.isNotEmpty
            ? activeDirectionTrips
            : allDirectionTrips,
        stopTimesByTrip,
      );

      if (representativeTrip == null) {
        continue;
      }

      final representativeStopTimes =
          stopTimesByTrip[gtfsStringValue(representativeTrip, 'trip_id')] ??
          const <_RawMap>[];

      if (representativeStopTimes.isEmpty) {
        continue;
      }

      final firstStopTime = representativeStopTimes.first;
      final lastStopTime = representativeStopTimes.last;

      final originStop = stopsById[gtfsStringValue(firstStopTime, 'stop_id')];
      final destinationStop =
          stopsById[gtfsStringValue(lastStopTime, 'stop_id')];

      final originName = gtfsStopName(originStop);
      final destinationName = gtfsStopName(destinationStop);

      directions.add(
        TransitLineDirection(
          key: directionKey,
          originName: originName,
          destinationName: destinationName,
          stopCount: representativeStopTimes.length,
          upcomingDepartures: gtfsUpcomingDepartures(
            trips: activeDirectionTrips,
            stopTimesByTrip: stopTimesByTrip,
            moment: moment,
            limit: 4,
          ),
          hasServiceToday: activeDirectionTrips.isNotEmpty,
        ),
      );
    }

    return directions;
  }

  List<TransitLineStop> _buildStopsForTrip({
    required _RawMap trip,
    required Map<String, List<_RawMap>> stopTimesByTrip,
    required Map<String, _RawMap> stopsById,
    required bool includeOfficialTimes,
  }) {
    final tripId = gtfsStringValue(trip, 'trip_id');
    final stopTimes = stopTimesByTrip[tripId] ?? const <_RawMap>[];

    return stopTimes
        .map((stopTime) {
          final stopId = gtfsStringValue(stopTime, 'stop_id');
          final stop = stopsById[stopId];

          return TransitLineStop(
            stopId: stopId,
            name: gtfsStopName(stop),
            officialTime: includeOfficialTimes
                ? gtfsFormatTime(gtfsStringValue(stopTime, 'arrival_time'))
                : null,
          );
        })
        .toList(growable: false);
  }
}
