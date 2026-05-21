import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class HomeMapColors {
  const HomeMapColors({
    this.fallbackBackgroundColor = const Color(0xFFF7F9FC),
  });

  // Colore mostrato se la mappa non ha ancora dimensioni valide.
  final Color fallbackBackgroundColor;
}

// Widget della mappa principale della Home.
// Mostra OpenStreetMap.
class HomeMap extends StatelessWidget {
  const HomeMap({
    super.key,
    this.colors = const HomeMapColors(),
  });

  // Palette colori propria della mappa.
  final HomeMapColors colors;

  // Centrato sull'Aquila.
  static const LatLng _initialCenter = LatLng(42.3498, 13.3995);

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
            initialZoom: 14,

            // Limiti di zoom.
            minZoom: 5,
            maxZoom: 19,

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
            // Layer base OpenStreetMap.
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.jivaio_app',
            ),
          ],
        );
      },
    );
  }
}