import 'dart:async';

import 'package:jivaio/data/repositories/transit_repository.dart';
import 'package:jivaio/data/services/saved_lines_service.dart';
import 'package:jivaio/domain/models/transit_line.dart';
import 'package:jivaio/domain/models/transit_stop.dart';

const testLine = TransitLine(
  routeId: 'route-1',
  shortName: '1',
  displayName: 'Linea Centro',
  directions: [
    TransitLineDirection(
      key: 'outbound',
      originName: 'Terminal',
      destinationName: 'Ospedale',
      upcomingDepartures: ['08:10'],
    ),
    TransitLineDirection(
      key: 'inbound',
      originName: 'Ospedale',
      destinationName: 'Terminal',
      upcomingDepartures: ['09:20'],
    ),
  ],
);

const secondTestLine = TransitLine(
  routeId: 'route-2',
  shortName: '2U',
  displayName: 'Linea Università',
  directions: [
    TransitLineDirection(
      key: 'loop',
      originName: 'Università',
      destinationName: 'Terminal',
      upcomingDepartures: [],
      hasServiceToday: false,
    ),
  ],
);

/// Fornisce dati sintetici senza caricare gli asset GTFS.
class FakeTransitRepository implements TransitRepository {
  List<TransitLine> lines = [testLine, secondTestLine];
  bool failLines = false;
  bool emptySchedule = false;
  bool failSchedule = false;
  int lineRequests = 0;
  final scheduleRequests = <({String routeId, String direction, int hour})>[];

  @override
  Future<List<TransitLine>> getLines({DateTime? moment}) async {
    lineRequests++;
    if (failLines) throw StateError('Caricamento non disponibile');
    return lines;
  }

  @override
  Future<List<TransitStop>> getMapStops() async => [];

  @override
  Future<TransitLineDirectionSchedule> getLineDirectionSchedule({
    required TransitLine line,
    required TransitLineDirection direction,
    DateTime? moment,
  }) async {
    scheduleRequests.add((
      routeId: line.routeId,
      direction: direction.key,
      hour: moment!.hour,
    ));
    if (failSchedule) throw StateError('Orari non disponibili');
    if (emptySchedule) {
      return const TransitLineDirectionSchedule(departures: [], stops: []);
    }
    final isOutbound = direction.key == 'outbound';
    return TransitLineDirectionSchedule(
      departures: [
        TransitLineDeparture(
          tripId: direction.key,
          departureTime: isOutbound ? '08:10' : '09:20',
        ),
      ],
      stops: [
        TransitLineStop(
          stopId: isOutbound ? 'stop-a' : 'stop-b',
          name: isOutbound ? 'Fermata Centro' : 'Fermata Parco',
          officialTime: isOutbound ? '08:15' : '09:25',
        ),
        const TransitLineStop(stopId: 'stop-end', name: 'Fermata finale'),
      ],
    );
  }
}

/// Registra le operazioni sui preferiti e controlla gli aggiornamenti remoti.
class FakeSavedLinesService implements SavedLinesService {
  final changes = StreamController<Set<String>>.broadcast();
  final writes = <({String userId, String routeId, bool saved})>[];
  Completer<void>? pendingWrite;

  @override
  Stream<Set<String>> watchSavedLineIds({required String userId}) =>
      changes.stream;

  Future<void> _write(String userId, String routeId, bool saved) async {
    writes.add((userId: userId, routeId: routeId, saved: saved));
    await pendingWrite?.future;
  }

  @override
  Future<void> saveLine({required String userId, required String routeId}) =>
      _write(userId, routeId, true);

  @override
  Future<void> removeLine({required String userId, required String routeId}) =>
      _write(userId, routeId, false);
}
