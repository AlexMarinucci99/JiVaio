/// Definisce i parametri di configurazione della mappa.
class MapConfig {
  const MapConfig._();

  static const double initialLatitude = 42.3498;
  static const double initialLongitude = 13.3995;

  static const double initialZoom = 14;
  static const double minZoom = 5;
  static const double maxZoom = 19;

  /// URL del tema Carto light usato per una resa più pulita di OpenStreetMap.
  static const String lightTileUrl =
      'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png';

  static const List<String> cartoSubdomains = ['a', 'b', 'c', 'd'];

  static const String userAgentPackageName = 'com.progetto.jivaio_app';
}
