import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../config/map_config.dart';
import '../../../domain/models/transit_stop.dart';
import '../../../domain/models/user_location.dart';
import '../theme/home_colors.dart';

// Widget della mappa principale della Home.
// Riceve dati già pronti e si occupa esclusivamente del rendering.
class HomeMap extends StatelessWidget {
  const HomeMap({
    super.key,
    required this.mapController,
    required this.stops,
    required this.onMapReady,
    this.userLocation,
    this.colors = const HomeMapColors(),
  });

  final MapController mapController;
  final List<TransitStop> stops;
  final UserLocation? userLocation;
  final VoidCallback onMapReady;
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
    final currentUserLocation = userLocation;

    return LayoutBuilder(
      builder: (context, constraints) {
        final hasValidSize =
            constraints.maxWidth.isFinite &&
            constraints.maxHeight.isFinite &&
            constraints.maxWidth > 0 &&
            constraints.maxHeight > 0;

        if (!hasValidSize) {
          return ColoredBox(color: colors.fallbackBackgroundColor);
        }

        return FlutterMap(
          mapController: mapController,
          options: MapOptions(
            initialCenter: _initialCenter,
            initialZoom: MapConfig.initialZoom,
            minZoom: MapConfig.minZoom,
            maxZoom: MapConfig.maxZoom,
            onMapReady: onMapReady,
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

            // Posizione utente: alone esterno + pallino blu centrale.
            if (currentUserLocation != null)
              CircleLayer(
                circles: [
                  CircleMarker(
                    point: LatLng(
                      currentUserLocation.latitude,
                      currentUserLocation.longitude,
                    ),
                    radius: 16,
                    color: colors.userLocationHaloColor,
                  ),
                  CircleMarker(
                    point: LatLng(
                      currentUserLocation.latitude,
                      currentUserLocation.longitude,
                    ),
                    radius: 7,
                    color: colors.userLocationMarkerColor,
                    borderColor: colors.userLocationMarkerBorderColor,
                    borderStrokeWidth: 2,
                  ),
                ],
              ),
          ],
        );
      },
    );
  }
}
