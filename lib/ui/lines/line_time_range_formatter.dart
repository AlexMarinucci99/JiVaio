/// Formatta la fascia oraria di un'ora nel formato `HH:00 - HH:00`.
String formatLineTimeRange(int startHour) {
  String formatHour(int hour) => hour.toString().padLeft(2, '0');

  return '${formatHour(startHour)}:00 - ${formatHour(startHour + 1)}:00';
}
