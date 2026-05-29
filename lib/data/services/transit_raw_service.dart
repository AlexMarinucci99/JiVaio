import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

//si occupa di leggere i file jso raw
class TransitRawBundle {
  const TransitRawBundle({
    required this.routes,
    required this.trips,
    required this.stopTimes,
    required this.stops,
    required this.calendar,
    required this.calendarDates,
  });

  final List<Map<String, dynamic>> routes;
  final List<Map<String, dynamic>> trips;
  final List<Map<String, dynamic>> stopTimes;
  final List<Map<String, dynamic>> stops;
  final List<Map<String, dynamic>> calendar;
  final List<Map<String, dynamic>> calendarDates;
}

class TransitRawService {
  const TransitRawService();

  static const String _basePath = 'assets/gtfs/raw';

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
    final rawContent = await rootBundle.loadString(path);
    final decoded = jsonDecode(rawContent);

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
