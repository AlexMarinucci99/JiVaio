import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../config/map_config.dart';

class HomeMapColors {
  const HomeMapColors({
    this.fallbackBackgroundColor = const Color(0xFFF7F9FC),
  });

  // Colore mostrato se la mappa non ha ancora dimensioni valide.
  final Color fallbackBackgroundColor;
}

// Widget della mappa principale della Home.
// Mostra una base map minimal per ridurre il rumore visivo.
class HomeMap extends StatelessWidget {
  const HomeMap({
    super.key,
    this.colors = const HomeMapColors(),
  });

  // Palette colori propria della mappa.
  final HomeMapColors colors;

  // Centrato sull'Aquila.
  static const LatLng _initialCenter = LatLng(
    MapConfig.initialLatitude,
    MapConfig.initialLongitude,
  );

  static final LatLngBounds _worldBounds = LatLngBounds(
    const LatLng(-85.05112878, -180),
    const LatLng(85.05112878, 180),
  );

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final hasValidSize =
            constraints.maxWidth.isFinite &&
            constraints.maxHeight.isFinite &&
            constraints.maxWidth > 0 &&
            constraints.maxHeight > 0;

        // Evita di costruire FlutterMap se il widget non ha ancora dimensioni valide.
        if (!hasValidSize) {
          return ColoredBox(color: colors.fallbackBackgroundColor);
        }

        return FlutterMap(
          options: MapOptions(
            // Posizione iniziale della mappa.
            initialCenter: _initialCenter,
            initialZoom: MapConfig.initialZoom,

            // Limiti di zoom.
            minZoom: MapConfig.minZoom,
            maxZoom: MapConfig.maxZoom,

            cameraConstraint: CameraConstraint.contain(bounds: _worldBounds),

            // Gesture abilitate.
            // Evitiamo rotazione e gesture inutili per ora.
            interactionOptions: const InteractionOptions(
              flags:
                  InteractiveFlag.drag |
                  InteractiveFlag.pinchZoom |
                  InteractiveFlag.doubleTapZoom,
            ),
          ),
          children: [
            // Layer base minimal.
            // È più pulito della tile standard di OpenStreetMap e lascia più spazio
            // ai futuri marker personalizzati di JiVaio.
            TileLayer(
              urlTemplate: MapConfig.lightTileUrl,
              subdomains: MapConfig.cartoSubdomains,
              userAgentPackageName: MapConfig.userAgentPackageName,
            ),

            // Attribuzione obbligatoria per dati e tile.
            RichAttributionWidget(
              attributions: [
                TextSourceAttribution(
                  '© OpenStreetMap contributors © CARTO',
                  onTap: () {},
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}