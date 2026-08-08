import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/foundation.dart' show compute;

/// Contiene i dati GTFS grezzi caricati dagli asset locali.
class TransitRawBundle {
  const TransitRawBundle({
    required this.routes,
    required this.trips,
    required this.stopTimes,
    required this.stops,
    required this.calendar,
    required this.calendarDates,
  });

  /// Righe del file `routes.json`.
  final List<Map<String, dynamic>> routes;

  /// Righe del file `trips.json`.
  final List<Map<String, dynamic>> trips;

  /// Righe del file `stop_times.json`.
  final List<Map<String, dynamic>> stopTimes;

  /// Righe del file `stops.json`.
  final List<Map<String, dynamic>> stops;

  /// Righe del file `calendar.json`.
  final List<Map<String, dynamic>> calendar;

  /// Righe del file `calendar_dates.json`.
  final List<Map<String, dynamic>> calendarDates;
}

/// Carica dagli asset locali i file GTFS convertiti in JSON.
///
/// Il servizio mantiene isolato l'accesso a [rootBundle], così il repository
/// lavora su dati già caricati e validati.
class TransitRawService {
  const TransitRawService();

  static const _basePath = 'assets/gtfs/raw';

  /// Restituisce il bundle completo dei dati GTFS grezzi.
  Future<TransitRawBundle> loadBundle() async {
    final results = await Future.wait([
      _loadJsonList('$_basePath/routes.json'),
      _loadJsonList('$_basePath/trips.json'),
      _loadJsonList('$_basePath/stop_times.json'),
      _loadJsonList('$_basePath/stops.json'),
      _loadJsonList('$_basePath/calendar.json'),
      _loadJsonList('$_basePath/calendar_dates.json'),
    ]);

    return TransitRawBundle(
      routes: results[0],
      trips: results[1],
      stopTimes: results[2],
      stops: results[3],
      calendar: results[4],
      calendarDates: results[5],
    );
  }

  Future<List<Map<String, dynamic>>> _loadJsonList(String path) async {
    final source = await rootBundle.loadString(path);
    final decoded = await compute(jsonDecode, source);

    if (decoded is! List) {
      throw FormatException('Il file $path non contiene una lista JSON.');
    }

    return decoded
        .map<Map<String, dynamic>>((item) {
          if (item is! Map) {
            throw FormatException('Elemento non valido nel file $path.');
          }

          return Map<String, dynamic>.from(item);
        })
        .toList(growable: false);
  }
}
