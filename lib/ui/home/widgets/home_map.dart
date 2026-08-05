import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../config/map_config.dart';
import '../../../domain/models/transit_stop.dart';
import '../../../domain/models/user_location.dart';
import '../theme/home_colors.dart';

/// Mappa principale della schermata Home.
///
/// Riceve fermate e posizione utente già pronte e si occupa
/// esclusivamente del rendering tramite Flutter Map.
class HomeMap extends StatelessWidget {
  const HomeMap({
    super.key,
    required this.mapController,
    required this.stops,
    required this.onMapReady,
    this.userLocation,
    this.colors = const HomeMapColors(),
  });

  /// Controller usato dalla schermata padre per muovere la mappa.
  final MapController mapController;

  /// Fermate del trasporto urbano da visualizzare sulla mappa.
  final List<TransitStop> stops;

  /// Posizione corrente dell'utente, se disponibile.
  final UserLocation? userLocation;

  /// Callback invocata quando la mappa è pronta.
  final VoidCallback onMapReady;

  /// Palette cromatica usata per marker e fallback.
  final HomeMapColors colors;

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
    final currentUserPoint = currentUserLocation == null
        ? null
        : LatLng(currentUserLocation.latitude, currentUserLocation.longitude);
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.biggest;

        if (!size.isFinite || size.isEmpty) {
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

            if (currentUserPoint != null)
              CircleLayer(
                circles: [
                  // Due marker sovrapposti rendono più leggibile la posizione utente.
                  CircleMarker(
                    point: currentUserPoint,
                    radius: 16,
                    color: colors.userLocationHaloColor,
                  ),
                  CircleMarker(
                    point: currentUserPoint,
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
