import 'gtfs_collection_utils.dart';
import 'gtfs_utils.dart';

/// Verifica se una corsa GTFS è attiva nella data [date].
bool gtfsIsTripActiveOnDate({
  required GtfsRawMap trip,
  required List<GtfsRawMap> calendar,
  required List<GtfsRawMap> calendarDates,
  required DateTime date,
}) {
  final serviceId = gtfsStringValue(trip, 'service_id');
  final dateKey =
      '${date.year.toString().padLeft(4, '0')}'
      '${date.month.toString().padLeft(2, '0')}'
      '${date.day.toString().padLeft(2, '0')}';

  for (final calendarDate in calendarDates) {
    if (gtfsStringValue(calendarDate, 'service_id') != serviceId) {
      continue;
    }

    if (gtfsStringValue(calendarDate, 'date') != dateKey) {
      continue;
    }

    final exceptionType = gtfsStringValue(calendarDate, 'exception_type');

    if (exceptionType == '1') {
      return true;
    }

    if (exceptionType == '2') {
      return false;
    }
  }

  GtfsRawMap? calendarRow;

  for (final row in calendar) {
    if (gtfsStringValue(row, 'service_id') == serviceId) {
      calendarRow = row;
      break;
    }
  }

  if (calendarRow == null) {
    return false;
  }

  final startDate = gtfsStringValue(calendarRow, 'start_date');
  final endDate = gtfsStringValue(calendarRow, 'end_date');

  if (dateKey.compareTo(startDate) < 0 || dateKey.compareTo(endDate) > 0) {
    return false;
  }

  return gtfsStringValue(calendarRow, _weekdayKeys[date.weekday - 1]) == '1';
}

const _weekdayKeys = [
  'monday',
  'tuesday',
  'wednesday',
  'thursday',
  'friday',
  'saturday',
  'sunday',
];
