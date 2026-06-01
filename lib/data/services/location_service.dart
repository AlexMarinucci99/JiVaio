import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

import '../../domain/models/location_access_result.dart';
import '../../domain/models/user_location.dart';

// Unico punto dell'app che conosce direttamente il plugin geolocator.
class LocationService {
  const LocationService();

  Future<LocationAccessResult> ensureLocationAccess() async {
    final isServiceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!isServiceEnabled) {
      return LocationAccessResult.serviceDisabled;
    }

    var permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      return LocationAccessResult.permissionDenied;
    }

    if (permission == LocationPermission.deniedForever) {
      return LocationAccessResult.permissionDeniedForever;
    }

    return LocationAccessResult.granted;
  }

  Future<UserLocation> getCurrentLocation() async {
    try {
      final position = await _getFreshPosition();

      return _toUserLocation(position);
    } catch (error, stackTrace) {
      debugPrint(
        '[LocationService] Recupero posizione corrente fallito: $error',
      );
      debugPrintStack(stackTrace: stackTrace);

      // Fallback: evita il fallimento completo se il GPS impiega
      // troppo tempo a ottenere un nuovo fix.
      final lastKnownPosition = await Geolocator.getLastKnownPosition();

      if (lastKnownPosition != null) {
        debugPrint(
          '[LocationService] Utilizzo ultima posizione nota disponibile.',
        );

        return _toUserLocation(lastKnownPosition);
      }

      rethrow;
    }
  }

  Future<Position> _getFreshPosition() async {
    try {
      // Primo tentativo: provider standard.
      // Su Android utilizza normalmente FusedLocationProviderClient.
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 20),
        ),
      );
    } catch (error, stackTrace) {
      debugPrint('[LocationService] Provider standard fallito: $error');
      debugPrintStack(stackTrace: stackTrace);

      if (defaultTargetPlatform != TargetPlatform.android) {
        rethrow;
      }

      // Secondo tentativo Android:
      // bypass del provider fused e utilizzo del LocationManager nativo.
      return Geolocator.getCurrentPosition(
        locationSettings: AndroidSettings(
          accuracy: LocationAccuracy.high,
          forceLocationManager: true,
          timeLimit: const Duration(seconds: 35),
        ),
      );
    }
  }

  UserLocation _toUserLocation(Position position) {
    return UserLocation(
      latitude: position.latitude,
      longitude: position.longitude,
    );
  }

  Future<bool> openLocationSettings() {
    return Geolocator.openLocationSettings();
  }

  Future<bool> openAppSettings() {
    return Geolocator.openAppSettings();
  }
}
