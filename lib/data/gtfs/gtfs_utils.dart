/// Restituisce un valore testuale normalizzato da una riga GTFS.
String gtfsStringValue(Map<String, dynamic> row, String key) {
  return row[key]?.toString().trim() ?? '';
}

/// Restituisce un valore numerico decimale da una riga GTFS.
double? gtfsDoubleValue(Map<String, dynamic> row, String key) {
  return double.tryParse(gtfsStringValue(row, key).replaceAll(',', '.'));
}

/// Restituisce un valore intero da una riga GTFS.
int gtfsIntValue(Map<String, dynamic> row, String key) {
  return int.tryParse(gtfsStringValue(row, key)) ?? 0;
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

/// Calcola l'ordinamento naturale di una linea a partire dal numero iniziale.
int gtfsNaturalLineOrder(String value) {
  final match = RegExp(r'^\d+').firstMatch(value.trim());
  return int.tryParse(match?.group(0) ?? '') ?? 10000;
}
