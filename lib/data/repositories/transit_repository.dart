import '../../domain/models/transit_line.dart';
import '../../domain/models/transit_stop.dart';
import '../gtfs/gtfs_calendar_utils.dart';
import '../gtfs/gtfs_collection_utils.dart';
import '../gtfs/gtfs_utils.dart';
import '../services/transit_raw_service.dart';

typedef _RawMap = GtfsRawMap;

/// Traduce i dati raw GTFS nei model del dominio.
class TransitRepository {
  TransitRepository({TransitRawService rawService = const TransitRawService()})
    : _rawService = rawService;

  final TransitRawService _rawService;

  TransitRawBundle? _cachedBundle;
  List<TransitStop>? _cachedMapStops;

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

      // In GTFS location_type = 0 identifica una fermata effettiva.
      // Se il campo manca o è vuoto, viene considerato 0.
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

      mapStops.add(
        TransitStop(
          stopId: stopId,
          name: _stopName(rawStop),
          latitude: latitude,
          longitude: longitude,
        ),
      );
    }

    final result = List<TransitStop>.unmodifiable(mapStops);
    _cachedMapStops = result;

    return result;
  }

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
          routeLongName: _buildRouteSubtitle(
            shortName: shortName,
            routeDescription: routeDescription,
          ),
          routeColor: _resolveRouteColor(route),
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
              _directionKeyOf(trip) == direction.key;
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

    final hourStart = DateTime(now.year, now.month, now.day, now.hour);
    final rangeStartMinutes = now.hour * 60;
    final rangeEndMinutes = rangeStartMinutes + 60;

    final departures = _departuresForRange(
      trips: activeTrips,
      stopTimesByTrip: stopTimesByTrip,
      startMinutes: rangeStartMinutes,
      endMinutes: rangeEndMinutes,
    );

    final selectedTripId = departures.isEmpty ? null : departures.first.tripId;

    final representativeTrip = _findRepresentativeTrip(
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
      routeId: line.routeId,
      directionKey: direction.key,
      timeRangeLabel: gtfsFormatHourRange(hourStart),
      departures: departures,
      stops: stops,
      selectedTripId: selectedTripId,
      hasServiceToday: activeTrips.isNotEmpty,
    );
  }

  Future<TransitRawBundle> _loadBundle() async {
    final cached = _cachedBundle;

    if (cached != null) {
      return cached;
    }

    final loaded = await _rawService.loadBundle();
    _cachedBundle = loaded;
    return loaded;
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
        routeTrips.map(_directionKeyOf).toSet().toList(growable: false)..sort();

    final directions = <TransitLineDirection>[];

    for (final directionKey in directionKeys) {
      final allDirectionTrips = routeTrips
          .where((trip) {
            return _directionKeyOf(trip) == directionKey;
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

      final representativeTrip = _firstTripWithStops(
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

      final originName = _stopName(originStop);
      final destinationName = _stopName(destinationStop);

      directions.add(
        TransitLineDirection(
          key: directionKey,
          originName: originName,
          destinationName: destinationName,
          stopCount: representativeStopTimes.length,
          upcomingDepartures: _upcomingDepartures(
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

  List<TransitLineDeparture> _departuresForRange({
    required List<_RawMap> trips,
    required Map<String, List<_RawMap>> stopTimesByTrip,
    required int startMinutes,
    required int endMinutes,
  }) {
    final departures = <TransitLineDeparture>[];

    for (final trip in trips) {
      final tripId = gtfsStringValue(trip, 'trip_id');
      final stopTimes = stopTimesByTrip[tripId] ?? const <_RawMap>[];

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
            name: _stopName(stop),
            sequence: gtfsIntValue(stopTime, 'stop_sequence'),
            officialTime: includeOfficialTimes
                ? gtfsFormatTime(gtfsStringValue(stopTime, 'arrival_time'))
                : null,
          );
        })
        .toList(growable: false);
  }

  _RawMap? _findRepresentativeTrip({
    required String? selectedTripId,
    required List<_RawMap> activeTrips,
    required List<_RawMap> allTrips,
    required Map<String, List<_RawMap>> stopTimesByTrip,
  }) {
    if (selectedTripId != null) {
      for (final trip in activeTrips) {
        if (gtfsStringValue(trip, 'trip_id') == selectedTripId) {
          return trip;
        }
      }
    }

    return _firstTripWithStops(
      activeTrips.isNotEmpty ? activeTrips : allTrips,
      stopTimesByTrip,
    );
  }

  _RawMap? _firstTripWithStops(
    List<_RawMap> trips,
    Map<String, List<_RawMap>> stopTimesByTrip,
  ) {
    final sortedTrips = [...trips]
      ..sort((a, b) {
        final aTime = _firstDepartureMinutes(a, stopTimesByTrip);
        final bTime = _firstDepartureMinutes(b, stopTimesByTrip);
        return aTime.compareTo(bTime);
      });

    for (final trip in sortedTrips) {
      final tripId = gtfsStringValue(trip, 'trip_id');
      final stopTimes = stopTimesByTrip[tripId] ?? const <_RawMap>[];

      if (stopTimes.isNotEmpty) {
        return trip;
      }
    }

    return null;
  }

  List<String> _upcomingDepartures({
    required List<_RawMap> trips,
    required Map<String, List<_RawMap>> stopTimesByTrip,
    required DateTime moment,
    required int limit,
  }) {
    final nowMinutes = moment.hour * 60 + moment.minute;
    final departures = <String>[];

    final sortedTrips = [...trips]
      ..sort((a, b) {
        final aTime = _firstDepartureMinutes(a, stopTimesByTrip);
        final bTime = _firstDepartureMinutes(b, stopTimesByTrip);
        return aTime.compareTo(bTime);
      });

    for (final trip in sortedTrips) {
      final tripId = gtfsStringValue(trip, 'trip_id');
      final stopTimes = stopTimesByTrip[tripId] ?? const <_RawMap>[];

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

  int _firstDepartureMinutes(
    _RawMap trip,
    Map<String, List<_RawMap>> stopTimesByTrip,
  ) {
    final tripId = gtfsStringValue(trip, 'trip_id');
    final stopTimes = stopTimesByTrip[tripId] ?? const <_RawMap>[];

    if (stopTimes.isEmpty) {
      return 1 << 30;
    }

    return gtfsTimeToMinutes(
      gtfsStringValue(stopTimes.first, 'departure_time'),
    );
  }

  String _directionKeyOf(_RawMap trip) {
    final directionId = gtfsStringValue(trip, 'direction_id');
    return directionId.isEmpty ? '0' : directionId;
  }

  String _resolveRouteColor(_RawMap route) {
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

  String _buildRouteSubtitle({
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

  String _stopName(_RawMap? stop) {
    if (stop == null) {
      return 'Fermata non disponibile';
    }

    final name = gtfsStringValue(stop, 'stop_name');

    if (name.isEmpty) {
      return 'Fermata non disponibile';
    }

    return _normalizeStopName(name);
  }

  String _normalizeStopName(String value) {
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
}
