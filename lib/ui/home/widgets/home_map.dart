import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../config/map_config.dart';
import '../../../domain/models/transit_stop.dart';

class HomeMapColors {
  const HomeMapColors({
    this.fallbackBackgroundColor = const Color(0xFFF7F9FC),
    this.stopMarkerColor = const Color(0xFF0B7A55),
    this.stopMarkerBorderColor = Colors.white,
  });

  // Colore mostrato se la mappa non ha ancora dimensioni valide.
  final Color fallbackBackgroundColor;

  // Colore centrale dei pallini delle fermate.
  final Color stopMarkerColor;

  // Bordo chiaro per rendere i marker leggibili sulla base map.
  final Color stopMarkerBorderColor;
}

// Widget della mappa principale della Home.
// Riceve dati già pronti e si occupa esclusivamente del rendering.
class HomeMap extends StatelessWidget {
  const HomeMap({
    super.key,
    required this.stops,
    this.colors = const HomeMapColors(),
  });

  final List<TransitStop> stops;

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

        // Evita di costruire FlutterMap se il widget
        // non ha ancora dimensioni valide.
        if (!hasValidSize) {
          return ColoredBox(color: colors.fallbackBackgroundColor);
        }

        return FlutterMap(
          options: MapOptions(
            initialCenter: _initialCenter,
            initialZoom: MapConfig.initialZoom,
            minZoom: MapConfig.minZoom,
            maxZoom: MapConfig.maxZoom,
            cameraConstraint: CameraConstraint.contain(bounds: _worldBounds),
            interactionOptions: const InteractionOptions(
              flags:
                  InteractiveFlag.drag |
                  InteractiveFlag.pinchZoom |
                  InteractiveFlag.doubleTapZoom,
            ),
          ),
          children: [
            TileLayer(
              urlTemplate: MapConfig.lightTileUrl,
              subdomains: MapConfig.cartoSubdomains,
              userAgentPackageName: MapConfig.userAgentPackageName,
            ),

            // Fermate GTFS mostrate come pallini verdi.
            if (stops.isNotEmpty)
              CircleLayer(
                circles: stops
                    .map(
                      (stop) => CircleMarker(
                        point: LatLng(stop.latitude, stop.longitude),
                        radius: 3.5,
                        color: colors.stopMarkerColor,
                        borderColor: colors.stopMarkerBorderColor,
                        borderStrokeWidth: 1.1,
                      ),
                    )
                    .toList(growable: false),
              ),
          ],
        );
      },
    );
  }
}