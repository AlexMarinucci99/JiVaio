import 'package:flutter_test/flutter_test.dart';

import 'package:jivaio/data/repositories/transit_repository.dart';
import 'package:jivaio/domain/models/transit_line.dart';
import 'package:jivaio/ui/lines/view_model/line_detail_view_model.dart';

class FakeTransitRepository implements TransitRepository {
  FakeTransitRepository({
    this.schedule,
    this.shouldThrow = false,
  });

  TransitLineDirectionSchedule? schedule;
  bool shouldThrow;

  int getScheduleCallCount = 0;
  TransitLine? lastLine;
  TransitLineDirection? lastDirection;
  DateTime? lastMoment;

 @override
Future<TransitLineDirectionSchedule> getLineDirectionSchedule({
  required TransitLine line,
  required TransitLineDirection direction,
  DateTime? moment,
}) async {
    getScheduleCallCount++;
lastLine = line;
lastDirection = direction;

final selectedMoment = moment ?? DateTime.now();
lastMoment = selectedMoment;

    if (shouldThrow) {
      throw Exception('Errore test schedule');
    }

    return schedule ??
        TransitLineDirectionSchedule(
          routeId: line.routeId,
          directionKey: direction.key,
          timeRangeLabel: _formatHourRange(selectedMoment.hour),
          departures: const [
            TransitLineDeparture(
              tripId: 'trip-1',
              departureTime: '08:10',
            ),
          ],
          stops: const [
            TransitLineStop(
              stopId: 'stop-1',
              name: 'Terminal Bus',
              sequence: 1,
              officialTime: '08:10',
            ),
            TransitLineStop(
              stopId: 'stop-2',
              name: 'Fontana Luminosa',
              sequence: 2,
              officialTime: '08:18',
            ),
          ],
          selectedTripId: 'trip-1',
        );
  }

  String _formatHourRange(int hour) {
    final endHour = hour + 1;

    return '${hour.toString().padLeft(2, '0')}:00 - '
        '${endHour.toString().padLeft(2, '0')}:00';
  }

  @override
  dynamic noSuchMethod(Invocation invocation) {
    return super.noSuchMethod(invocation);
  }
}

void main() {
  const outboundDirection = TransitLineDirection(
    key: 'outbound',
    originName: 'Terminal Bus',
    destinationName: 'Università',
    stopCount: 8,
    upcomingDepartures: ['08:10', '08:40'],
  );

  const returnDirection = TransitLineDirection(
    key: 'return',
    originName: 'Università',
    destinationName: 'Terminal Bus',
    stopCount: 8,
    upcomingDepartures: ['10:00'],
  );

  const testLine = TransitLine(
    routeId: 'line-1',
    shortName: '1',
    displayName: 'Linea 1',
    routeLongName: 'Terminal Bus - Università',
    routeColor: '0B7A55',
    directions: [
      outboundDirection,
      returnDirection,
    ],
  );

  LineDetailViewModel buildViewModel({
    TransitLine line = testLine,
    FakeTransitRepository? repository,
  }) {
    return LineDetailViewModel(
      line: line,
      repository: repository ?? FakeTransitRepository(),
    );
  }

  group('LineDetailViewModel', () {
    test('parte con stato iniziale corretto', () {
      final viewModel = buildViewModel();

      expect(viewModel.line, testLine);
      expect(viewModel.selectedDirectionIndex, 0);
      expect(viewModel.selectedDirection, outboundDirection);
      expect(viewModel.schedule, isNull);
      expect(viewModel.departures, isEmpty);
      expect(viewModel.stops, isEmpty);
      expect(viewModel.selectedTripId, isNull);
      expect(viewModel.isLoadingSchedule, isFalse);
      expect(viewModel.errorMessage, isNull);
      expect(viewModel.isAutomaticTime, isTrue);
      expect(viewModel.selectedManualHour, isNull);

      viewModel.dispose();
    });

    test('riconosce direzioni disponibili e cambio direzione possibile', () {
      final viewModel = buildViewModel();

      expect(viewModel.hasDirections, isTrue);
      expect(viewModel.canSwapDirection, isTrue);
      expect(viewModel.canToggleDirection, isTrue);

      viewModel.dispose();
    });

    test('manualHours contiene le fasce da 5 a 22', () {
      final viewModel = buildViewModel();

      expect(viewModel.manualHours.length, 18);
      expect(viewModel.manualHours.first, 5);
      expect(viewModel.manualHours.last, 22);

      viewModel.dispose();
    });

    test('loadSchedule carica partenze e fermate dal repository', () async {
      final repository = FakeTransitRepository();
      final viewModel = buildViewModel(
        repository: repository,
      );

      await viewModel.loadSchedule();

      expect(repository.getScheduleCallCount, 1);
      expect(repository.lastLine, testLine);
      expect(repository.lastDirection, outboundDirection);

      expect(viewModel.schedule, isNotNull);
      expect(viewModel.departures.length, 1);
      expect(viewModel.departures.first.departureTime, '08:10');
      expect(viewModel.stops.length, 2);
      expect(viewModel.stops.first.name, 'Terminal Bus');
      expect(viewModel.selectedTripId, 'trip-1');
      expect(viewModel.isLoadingSchedule, isFalse);
      expect(viewModel.errorMessage, isNull);

      viewModel.dispose();
    });

    test('loadSchedule espone messaggio errore se il repository fallisce',
        () async {
      final repository = FakeTransitRepository(
        shouldThrow: true,
      );

      final viewModel = buildViewModel(
        repository: repository,
      );

      await viewModel.loadSchedule();

      expect(repository.getScheduleCallCount, 1);
      expect(viewModel.schedule, isNull);
      expect(viewModel.departures, isEmpty);
      expect(viewModel.stops, isEmpty);
      expect(viewModel.isLoadingSchedule, isFalse);
      expect(
        viewModel.errorMessage,
        'Impossibile caricare partenze e fermate.',
      );

      viewModel.dispose();
    });

    test('loadSchedule gestisce linea senza direzioni', () async {
      const lineWithoutDirections = TransitLine(
        routeId: 'empty-line',
        shortName: 'X',
        displayName: 'Linea senza direzioni',
        routeLongName: 'Linea non disponibile',
        routeColor: '0B7A55',
        directions: [],
      );

      final repository = FakeTransitRepository();

      final viewModel = buildViewModel(
        line: lineWithoutDirections,
        repository: repository,
      );

      await viewModel.loadSchedule();

      expect(repository.getScheduleCallCount, 0);
      expect(viewModel.selectedDirection, isNull);
      expect(viewModel.schedule, isNull);
      expect(viewModel.errorMessage, 'Direzione non disponibile.');

      viewModel.dispose();
    });

    test('toggleDirection cambia direzione e ricarica lo schedule', () async {
      final repository = FakeTransitRepository();
      final viewModel = buildViewModel(
        repository: repository,
      );

      await viewModel.loadSchedule();

      expect(viewModel.selectedDirectionIndex, 0);
      expect(viewModel.selectedDirection, outboundDirection);

      await viewModel.toggleDirection();

      expect(viewModel.selectedDirectionIndex, 1);
      expect(viewModel.selectedDirection, returnDirection);
      expect(repository.getScheduleCallCount, 2);
      expect(repository.lastDirection, returnDirection);

      viewModel.dispose();
    });

    test('toggleDirection non cambia nulla per linea unidirezionale 2U',
        () async {
      const oneWayLine = TransitLine(
        routeId: 'line-2u',
        shortName: '2U',
        displayName: 'Linea 2U',
        routeLongName: 'Linea universitaria',
        routeColor: '0B7A55',
        directions: [
          outboundDirection,
          returnDirection,
        ],
      );

      final repository = FakeTransitRepository();

      final viewModel = buildViewModel(
        line: oneWayLine,
        repository: repository,
      );

      expect(viewModel.canSwapDirection, isTrue);
      expect(viewModel.canToggleDirection, isFalse);

      await viewModel.toggleDirection();

      expect(viewModel.selectedDirectionIndex, 0);
      expect(repository.getScheduleCallCount, 0);

      viewModel.dispose();
    });

    test('selectManualHour imposta ora manuale e ricarica lo schedule',
        () async {
      final repository = FakeTransitRepository();
      final viewModel = buildViewModel(
        repository: repository,
      );

      await viewModel.selectManualHour(14);

      expect(viewModel.isAutomaticTime, isFalse);
      expect(viewModel.selectedManualHour, 14);
      expect(viewModel.timeRangeLabel, '14:00 - 15:00');
      expect(repository.lastMoment?.hour, 14);
      expect(repository.getScheduleCallCount, 1);

      viewModel.dispose();
    });

    test('selectAutomaticTime torna alla modalità automatica e ricarica',
        () async {
      final repository = FakeTransitRepository();
      final viewModel = buildViewModel(
        repository: repository,
      );

      await viewModel.selectManualHour(14);

      expect(viewModel.isAutomaticTime, isFalse);
      expect(viewModel.selectedManualHour, 14);

      await viewModel.selectAutomaticTime();

      expect(viewModel.isAutomaticTime, isTrue);
      expect(viewModel.selectedManualHour, isNull);
      expect(repository.getScheduleCallCount, 2);

      viewModel.dispose();
    });

    test('notifica i listener durante loadSchedule', () async {
      final repository = FakeTransitRepository();
      final viewModel = buildViewModel(
        repository: repository,
      );

      var notifyCount = 0;

      viewModel.addListener(() {
        notifyCount++;
      });

      await viewModel.loadSchedule();

      expect(notifyCount, 2);

      viewModel.dispose();
    });
  });
}