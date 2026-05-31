import '../../domain/models/transit_line.dart';
import '../../domain/models/transit_stop.dart';
import '../services/transit_raw_service.dart';

// Traduce i dati raw nei model del dominio.

typedef _RawMap = Map<String, dynamic>;

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
      final stopId = _stringValue(rawStop, 'stop_id');
      final latitude = _doubleValue(rawStop, 'stop_lat');
      final longitude = _doubleValue(rawStop, 'stop_lon');

      // In GTFS location_type = 0 identifica una fermata effettiva.
      // Se il campo manca o è vuoto, viene considerato 0.
      final locationType = _intValue(rawStop, 'location_type');

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

    final stopTimesByTrip = _groupStopTimesByTrip(bundle.stopTimes);
    final stopsById = _mapById(bundle.stops, 'stop_id');
    final tripsByRoute = _groupBy(bundle.trips, 'route_id');

    final lines = <TransitLine>[];

    for (final route in bundle.routes) {
      final routeId = _stringValue(route, 'route_id');
      final routeTrips = tripsByRoute[routeId] ?? const <_RawMap>[];

      if (routeTrips.isEmpty) {
        continue;
      }

      final directions = _buildDirections(
        routeTrips: routeTrips,
        bundle: bundle,
        stopTimesByTrip: stopTimesByTrip,
        stopsById: stopsById,
        moment: now,
      );

      if (directions.isEmpty) {
        continue;
      }

      final shortName = _stringValue(route, 'route_short_name');
      final longName = _stringValue(route, 'route_long_name');
      final routeDescription = _stringValue(route, 'route_desc');

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
      final byNumber = _naturalLineOrder(
        a.shortName,
      ).compareTo(_naturalLineOrder(b.shortName));

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

    final stopTimesByTrip = _groupStopTimesByTrip(bundle.stopTimes);
    final stopsById = _mapById(bundle.stops, 'stop_id');

    final routeTrips = bundle.trips
        .where((trip) {
          return _stringValue(trip, 'route_id') == line.routeId &&
              _directionKeyOf(trip) == direction.key;
        })
        .toList(growable: false);

    final activeTrips = routeTrips
        .where((trip) {
          return _isTripActiveOnDate(trip: trip, bundle: bundle, date: now);
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
      timeRangeLabel: _formatHourRange(hourStart),
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
            return _isTripActiveOnDate(
              trip: trip,
              bundle: bundle,
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
          stopTimesByTrip[_stringValue(representativeTrip, 'trip_id')] ??
          const <_RawMap>[];

      if (representativeStopTimes.isEmpty) {
        continue;
      }

      final firstStopTime = representativeStopTimes.first;
      final lastStopTime = representativeStopTimes.last;

      final originStop = stopsById[_stringValue(firstStopTime, 'stop_id')];
      final destinationStop = stopsById[_stringValue(lastStopTime, 'stop_id')];

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
      final tripId = _stringValue(trip, 'trip_id');
      final stopTimes = stopTimesByTrip[tripId] ?? const <_RawMap>[];

      if (stopTimes.isEmpty) {
        continue;
      }

      final departureTime = _stringValue(stopTimes.first, 'departure_time');
      final departureMinutes = _timeToMinutes(departureTime);

      if (departureMinutes >= startMinutes && departureMinutes < endMinutes) {
        departures.add(
          TransitLineDeparture(
            tripId: tripId,
            departureTime: _formatGtfsTime(departureTime),
          ),
        );
      }
    }

    departures.sort((a, b) {
      return _timeToMinutes(
        a.departureTime,
      ).compareTo(_timeToMinutes(b.departureTime));
    });

    return departures;
  }

  List<TransitLineStop> _buildStopsForTrip({
    required _RawMap trip,
    required Map<String, List<_RawMap>> stopTimesByTrip,
    required Map<String, _RawMap> stopsById,
    required bool includeOfficialTimes,
  }) {
    final tripId = _stringValue(trip, 'trip_id');
    final stopTimes = stopTimesByTrip[tripId] ?? const <_RawMap>[];

    return stopTimes
        .map((stopTime) {
          final stopId = _stringValue(stopTime, 'stop_id');
          final stop = stopsById[stopId];

          return TransitLineStop(
            stopId: stopId,
            name: _stopName(stop),
            sequence: _intValue(stopTime, 'stop_sequence'),
            officialTime: includeOfficialTimes
                ? _formatGtfsTime(_stringValue(stopTime, 'arrival_time'))
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
        if (_stringValue(trip, 'trip_id') == selectedTripId) {
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
      final tripId = _stringValue(trip, 'trip_id');
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
      final tripId = _stringValue(trip, 'trip_id');
      final stopTimes = stopTimesByTrip[tripId] ?? const <_RawMap>[];

      if (stopTimes.isEmpty) {
        continue;
      }

      final departureTime = _stringValue(stopTimes.first, 'departure_time');
      final departureMinutes = _timeToMinutes(departureTime);

      if (departureMinutes < nowMinutes) {
        continue;
      }

      departures.add(_formatGtfsTime(departureTime));

      if (departures.length == limit) {
        break;
      }
    }

    return departures;
  }

  bool _isTripActiveOnDate({
    required _RawMap trip,
    required TransitRawBundle bundle,
    required DateTime date,
  }) {
    final serviceId = _stringValue(trip, 'service_id');
    return _isServiceActiveOnDate(
      serviceId: serviceId,
      bundle: bundle,
      date: date,
    );
  }

  bool _isServiceActiveOnDate({
    required String serviceId,
    required TransitRawBundle bundle,
    required DateTime date,
  }) {
    final dateKey = _formatGtfsDate(date);

    for (final calendarDate in bundle.calendarDates) {
      if (_stringValue(calendarDate, 'service_id') != serviceId) {
        continue;
      }

      if (_stringValue(calendarDate, 'date') != dateKey) {
        continue;
      }

      final exceptionType = _stringValue(calendarDate, 'exception_type');

      if (exceptionType == '1') {
        return true;
      }

      if (exceptionType == '2') {
        return false;
      }
    }

    _RawMap? calendarRow;

    for (final row in bundle.calendar) {
      if (_stringValue(row, 'service_id') == serviceId) {
        calendarRow = row;
        break;
      }
    }

    if (calendarRow == null) {
      return false;
    }

    final startDate = _stringValue(calendarRow, 'start_date');
    final endDate = _stringValue(calendarRow, 'end_date');

    if (dateKey.compareTo(startDate) < 0 || dateKey.compareTo(endDate) > 0) {
      return false;
    }

    final weekdayKey = _weekdayKey(date);
    return _stringValue(calendarRow, weekdayKey) == '1';
  }

  Map<String, List<_RawMap>> _groupStopTimesByTrip(List<_RawMap> stopTimes) {
    final grouped = _groupBy(stopTimes, 'trip_id');

    for (final entry in grouped.entries) {
      entry.value.sort((a, b) {
        return _intValue(
          a,
          'stop_sequence',
        ).compareTo(_intValue(b, 'stop_sequence'));
      });
    }

    return grouped;
  }

  Map<String, List<_RawMap>> _groupBy(List<_RawMap> rows, String key) {
    final grouped = <String, List<_RawMap>>{};

    for (final row in rows) {
      final value = _stringValue(row, key);

      if (value.isEmpty) {
        continue;
      }

      grouped.putIfAbsent(value, () => <_RawMap>[]).add(row);
    }

    return grouped;
  }

  Map<String, _RawMap> _mapById(List<_RawMap> rows, String key) {
    final mapped = <String, _RawMap>{};

    for (final row in rows) {
      final value = _stringValue(row, key);

      if (value.isEmpty) {
        continue;
      }

      mapped[value] = row;
    }

    return mapped;
  }

  int _firstDepartureMinutes(
    _RawMap trip,
    Map<String, List<_RawMap>> stopTimesByTrip,
  ) {
    final tripId = _stringValue(trip, 'trip_id');
    final stopTimes = stopTimesByTrip[tripId] ?? const <_RawMap>[];

    if (stopTimes.isEmpty) {
      return 1 << 30;
    }

    return _timeToMinutes(_stringValue(stopTimes.first, 'departure_time'));
  }

  String _directionKeyOf(_RawMap trip) {
    final directionId = _stringValue(trip, 'direction_id');
    return directionId.isEmpty ? '0' : directionId;
  }

  String _resolveRouteColor(_RawMap route) {
    final rawColor = _stringValue(route, 'route_color');

    if (rawColor.length == 6) {
      return rawColor;
    }

    final shortName = _stringValue(route, 'route_short_name').toUpperCase();

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

    final name = _stringValue(stop, 'stop_name');

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

  String _stringValue(_RawMap row, String key) {
    final value = row[key];

    if (value == null) {
      return '';
    }

    return value.toString().trim();
  }

  double? _doubleValue(_RawMap row, String key) {
    final value = _stringValue(row, key);

    if (value.isEmpty) {
      return null;
    }

    return double.tryParse(value.replaceAll(',', '.'));
  }

  int _intValue(_RawMap row, String key) {
    final value = int.tryParse(_stringValue(row, key));
    return value ?? 0;
  }

  int _timeToMinutes(String value) {
    final parts = value.split(':');

    if (parts.length < 2) {
      return 1 << 30;
    }

    final hours = int.tryParse(parts[0]) ?? 0;
    final minutes = int.tryParse(parts[1]) ?? 0;

    return hours * 60 + minutes;
  }

  String _formatGtfsTime(String value) {
    final parts = value.split(':');

    if (parts.length < 2) {
      return value;
    }

    final hours = int.tryParse(parts[0]) ?? 0;
    final minutes = int.tryParse(parts[1]) ?? 0;

    return '${hours.toString().padLeft(2, '0')}:'
        '${minutes.toString().padLeft(2, '0')}';
  }

  String _formatHourRange(DateTime hourStart) {
    final startHour = hourStart.hour;
    final endHour = startHour + 1;

    return '${startHour.toString().padLeft(2, '0')}:00 - '
        '${endHour.toString().padLeft(2, '0')}:00';
  }

  String _formatGtfsDate(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');

    return '$year$month$day';
  }

  String _weekdayKey(DateTime date) {
    switch (date.weekday) {
      case DateTime.monday:
        return 'monday';
      case DateTime.tuesday:
        return 'tuesday';
      case DateTime.wednesday:
        return 'wednesday';
      case DateTime.thursday:
        return 'thursday';
      case DateTime.friday:
        return 'friday';
      case DateTime.saturday:
        return 'saturday';
      case DateTime.sunday:
        return 'sunday';
    }

    return 'monday';
  }

  int _naturalLineOrder(String value) {
    final match = RegExp(r'^\d+').firstMatch(value.trim());

    if (match == null) {
      return 10000;
    }

    return int.tryParse(match.group(0) ?? '') ?? 10000;
  }
}
