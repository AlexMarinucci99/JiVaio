import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

import '../../domain/models/location_access_result.dart';
import '../../domain/models/user_location.dart';
import 'location_service.dart';

/// Implementazione di [LocationService] basata sul plugin Geolocator.
///
/// È l'unico punto dell'app che conosce direttamente il plugin esterno.
class GeolocatorLocationService implements LocationService {
  const GeolocatorLocationService();

  @override
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

  @override
  Future<UserLocation> getCurrentLocation() async {
    try {
      final position = await _getFreshPosition();

      return _toUserLocation(position);
    } catch (error, stackTrace) {
      debugPrint(
        '[GeolocatorLocationService] Recupero posizione corrente fallito: $error',
      );
      debugPrintStack(stackTrace: stackTrace);

      // Fallback necessario perché su alcuni dispositivi Android
      // il nuovo fix GPS può richiedere più tempo del previsto.
      final lastKnownPosition = await Geolocator.getLastKnownPosition();

      if (lastKnownPosition != null) {
        debugPrint(
          '[GeolocatorLocationService] Utilizzo ultima posizione nota disponibile.',
        );

        return _toUserLocation(lastKnownPosition);
      }

      rethrow;
    }
  }

  Future<Position> _getFreshPosition() async {
    try {
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 20),
        ),
      );
    } catch (error, stackTrace) {
      debugPrint(
        '[GeolocatorLocationService] Provider standard fallito: $error',
      );
      debugPrintStack(stackTrace: stackTrace);

      if (defaultTargetPlatform != TargetPlatform.android) {
        rethrow;
      }

      // Su Android manteniamo un secondo tentativo tramite LocationManager
      // perché alcuni emulatori o device gestiscono male il provider fused.
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

  @override
  Future<bool> openLocationSettings() {
    return Geolocator.openLocationSettings();
  }

  @override
  Future<bool> openAppSettings() {
    return Geolocator.openAppSettings();
  }
}
