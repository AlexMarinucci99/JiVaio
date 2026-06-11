import 'package:flutter_test/flutter_test.dart';

import 'package:jivaio/domain/models/transit_line.dart';

void main() {
  group('TransitLine', () {
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

    test('primaryDirection restituisce la prima direzione disponibile', () {
      const line = TransitLine(
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

      expect(line.primaryDirection, outboundDirection);
      expect(line.primaryDirection.key, 'outbound');
    });

    test('isUnidirectional è false per una linea normale', () {
      const line = TransitLine(
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

      expect(line.isUnidirectional, isFalse);
    });

    test('isUnidirectional è true per la linea 2U', () {
      const line = TransitLine(
        routeId: 'line-2u',
        shortName: '2U',
        displayName: 'Linea 2U',
        routeLongName: 'Linea universitaria',
        routeColor: '0B7A55',
        directions: [
          outboundDirection,
        ],
      );

      expect(line.isUnidirectional, isTrue);
    });

    test('isUnidirectional normalizza spazi e maiuscole', () {
      const line = TransitLine(
        routeId: 'line-2u',
        shortName: ' 2u ',
        displayName: 'Linea 2U',
        routeLongName: 'Linea universitaria',
        routeColor: '0B7A55',
        directions: [
          outboundDirection,
        ],
      );

      expect(line.isUnidirectional, isTrue);
    });
  });

  group('TransitLineDirection', () {
    test('hasUpcomingDepartures è true quando ci sono partenze', () {
      const direction = TransitLineDirection(
        key: 'outbound',
        originName: 'Terminal Bus',
        destinationName: 'Università',
        stopCount: 8,
        upcomingDepartures: ['08:10'],
      );

      expect(direction.hasUpcomingDepartures, isTrue);
    });

    test('hasUpcomingDepartures è false quando non ci sono partenze', () {
      const direction = TransitLineDirection(
        key: 'outbound',
        originName: 'Terminal Bus',
        destinationName: 'Università',
        stopCount: 8,
        upcomingDepartures: [],
      );

      expect(direction.hasUpcomingDepartures, isFalse);
    });

    test('emptyStateMessage segnala nessun servizio oggi', () {
      const direction = TransitLineDirection(
        key: 'outbound',
        originName: 'Terminal Bus',
        destinationName: 'Università',
        stopCount: 8,
        upcomingDepartures: [],
        hasServiceToday: false,
      );

      expect(direction.emptyStateMessage, 'Nessuna corsa attiva per oggi.');
    });

    test('emptyStateMessage segnala nessuna altra partenza disponibile', () {
      const direction = TransitLineDirection(
        key: 'outbound',
        originName: 'Terminal Bus',
        destinationName: 'Università',
        stopCount: 8,
        upcomingDepartures: [],
      );

      expect(
        direction.emptyStateMessage,
        'Nessuna altra partenza disponibile per oggi.',
      );
    });
  });

  group('TransitLineDirectionSchedule', () {
    const departures = [
      TransitLineDeparture(
        tripId: 'trip-1',
        departureTime: '08:10',
      ),
    ];

    const stops = [
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
    ];

    test('hasDepartures e hasStops sono true quando i dati sono presenti', () {
      const schedule = TransitLineDirectionSchedule(
        routeId: 'line-1',
        directionKey: 'outbound',
        timeRangeLabel: '08:00 - 09:00',
        departures: departures,
        stops: stops,
        selectedTripId: 'trip-1',
      );

      expect(schedule.hasDepartures, isTrue);
      expect(schedule.hasStops, isTrue);
      expect(schedule.selectedTripId, 'trip-1');
    });

    test('hasDepartures e hasStops sono false quando le liste sono vuote', () {
      const schedule = TransitLineDirectionSchedule(
        routeId: 'line-1',
        directionKey: 'outbound',
        timeRangeLabel: '08:00 - 09:00',
        departures: [],
        stops: [],
      );

      expect(schedule.hasDepartures, isFalse);
      expect(schedule.hasStops, isFalse);
      expect(schedule.selectedTripId, isNull);
    });

    test('emptyDeparturesMessage segnala nessun servizio oggi', () {
      const schedule = TransitLineDirectionSchedule(
        routeId: 'line-1',
        directionKey: 'outbound',
        timeRangeLabel: '08:00 - 09:00',
        departures: [],
        stops: [],
        hasServiceToday: false,
      );

      expect(schedule.emptyDeparturesMessage, 'Nessuna corsa attiva per oggi.');
    });

    test('emptyDeparturesMessage segnala nessun bus nella fascia oraria', () {
      const schedule = TransitLineDirectionSchedule(
        routeId: 'line-1',
        directionKey: 'outbound',
        timeRangeLabel: '08:00 - 09:00',
        departures: [],
        stops: [],
      );

      expect(
        schedule.emptyDeparturesMessage,
        'Non ci sono bus in questa fascia oraria.',
      );
    });
  });

  group('TransitLineStop', () {
    test('hasOfficialTime è true quando officialTime è valorizzato', () {
      const stop = TransitLineStop(
        stopId: 'stop-1',
        name: 'Terminal Bus',
        sequence: 1,
        officialTime: '08:10',
      );

      expect(stop.hasOfficialTime, isTrue);
    });

    test('hasOfficialTime è false quando officialTime è null', () {
      const stop = TransitLineStop(
        stopId: 'stop-1',
        name: 'Terminal Bus',
        sequence: 1,
        officialTime: null,
      );

      expect(stop.hasOfficialTime, isFalse);
    });

    test('hasOfficialTime è false quando officialTime contiene solo spazi', () {
      const stop = TransitLineStop(
        stopId: 'stop-1',
        name: 'Terminal Bus',
        sequence: 1,
        officialTime: '   ',
      );

      expect(stop.hasOfficialTime, isFalse);
    });
  });
}