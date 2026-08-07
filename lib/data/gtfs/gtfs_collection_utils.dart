import 'gtfs_utils.dart';

/// Rappresenta una riga raw proveniente dai dati GTFS.
typedef GtfsRawMap = Map<String, dynamic>;

/// Raggruppa le righe GTFS in base al valore associato a [key].
Map<String, List<GtfsRawMap>> gtfsGroupBy(List<GtfsRawMap> rows, String key) {
  final grouped = <String, List<GtfsRawMap>>{};

  for (final row in rows) {
    final value = gtfsStringValue(row, key);

    if (value.isNotEmpty) {
      grouped.putIfAbsent(value, () => <GtfsRawMap>[]).add(row);
    }
  }

  return grouped;
}

/// Indicizza le righe GTFS usando il valore associato a [key].
Map<String, GtfsRawMap> gtfsMapById(List<GtfsRawMap> rows, String key) {
  final mapped = <String, GtfsRawMap>{};

  for (final row in rows) {
    final value = gtfsStringValue(row, key);

    if (value.isNotEmpty) {
      mapped[value] = row;
    }
  }

  return mapped;
}

/// Raggruppa gli orari GTFS per corsa e li ordina per sequenza fermata.
Map<String, List<GtfsRawMap>> gtfsGroupStopTimesByTrip(
  List<GtfsRawMap> stopTimes,
) {
  final grouped = gtfsGroupBy(stopTimes, 'trip_id');

  for (final entry in grouped.entries) {
    entry.value.sort(
      (a, b) => gtfsIntValue(
        a,
        'stop_sequence',
      ).compareTo(gtfsIntValue(b, 'stop_sequence')),
    );
  }

  return grouped;
}
