import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

import '../../domain/models/location_access_result.dart';
import '../../domain/models/user_location.dart';
import 'location_service.dart';

/// Implementa [LocationService] usando il plugin Geolocator.
///
/// Questo service isola l'accesso al plugin esterno e restituisce al resto
/// dell'app modelli di dominio indipendenti da Geolocator.
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

      // Manteniamo il fallback perché il fix GPS può richiedere più tempo
      // del previsto su alcuni dispositivi Android.
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

      // Su Android usiamo un secondo tentativo perché emulatori e alcuni
      // dispositivi possono gestire male il provider fused.
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
