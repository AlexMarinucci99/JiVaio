/// Restituisce un valore testuale normalizzato da una riga GTFS.
String gtfsStringValue(Map<String, dynamic> row, String key) {
  final value = row[key];

  if (value == null) {
    return '';
  }

  return value.toString().trim();
}

/// Restituisce un valore numerico decimale da una riga GTFS.
double? gtfsDoubleValue(Map<String, dynamic> row, String key) {
  final value = gtfsStringValue(row, key);

  if (value.isEmpty) {
    return null;
  }

  return double.tryParse(value.replaceAll(',', '.'));
}

/// Restituisce un valore intero da una riga GTFS.
int gtfsIntValue(Map<String, dynamic> row, String key) {
  final value = int.tryParse(gtfsStringValue(row, key));
  return value ?? 0;
}

/// Converte un orario GTFS nel numero di minuti dall'inizio del servizio.
int gtfsTimeToMinutes(String value) {
  final parts = value.split(':');

  if (parts.length < 2) {
    return 1 << 30;
  }

  final hours = int.tryParse(parts[0]) ?? 0;
  final minutes = int.tryParse(parts[1]) ?? 0;

  return hours * 60 + minutes;
}

/// Formatta un orario GTFS nel formato HH:mm.
String gtfsFormatTime(String value) {
  final parts = value.split(':');

  if (parts.length < 2) {
    return value;
  }

  final hours = int.tryParse(parts[0]) ?? 0;
  final minutes = int.tryParse(parts[1]) ?? 0;

  return '${hours.toString().padLeft(2, '0')}:'
      '${minutes.toString().padLeft(2, '0')}';
}

/// Restituisce l'etichetta della fascia oraria mostrata nel dettaglio linea.
String gtfsFormatHourRange(DateTime hourStart) {
  final startHour = hourStart.hour;
  final endHour = startHour + 1;

  return '${startHour.toString().padLeft(2, '0')}:00 - '
      '${endHour.toString().padLeft(2, '0')}:00';
}

/// Converte una data nel formato GTFS yyyyMMdd.
String gtfsFormatDate(DateTime date) {
  final year = date.year.toString().padLeft(4, '0');
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');

  return '$year$month$day';
}

/// Restituisce la chiave GTFS del giorno della settimana.
String gtfsWeekdayKey(DateTime date) {
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

/// Calcola l'ordinamento naturale di una linea a partire dal numero iniziale.
int gtfsNaturalLineOrder(String value) {
  final match = RegExp(r'^\d+').firstMatch(value.trim());

  if (match == null) {
    return 10000;
  }

  return int.tryParse(match.group(0) ?? '') ?? 10000;
}
