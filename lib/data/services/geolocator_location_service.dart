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
    if (!await Geolocator.isLocationServiceEnabled()) {
      return LocationAccessResult.serviceDisabled;
    }

    var permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    return switch (permission) {
      LocationPermission.denied => LocationAccessResult.permissionDenied,
      LocationPermission.deniedForever =>
        LocationAccessResult.permissionDeniedForever,
      _ => LocationAccessResult.granted,
    };
  }

  @override
  Future<UserLocation> getCurrentLocation() async {
    try {
      return _toUserLocation(await _getFreshPosition());
    } catch (error, stackTrace) {
      debugPrint(
        '[GeolocatorLocationService] '
        'Recupero posizione corrente fallito: $error',
      );
      debugPrintStack(stackTrace: stackTrace);

      final lastKnownPosition = await Geolocator.getLastKnownPosition();

      if (lastKnownPosition != null) {
        debugPrint(
          '[GeolocatorLocationService] '
          'Utilizzo ultima posizione nota disponibile.',
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

      // Secondo tentativo Android tramite il Location Manager.
      return Geolocator.getCurrentPosition(
        locationSettings: AndroidSettings(
          accuracy: LocationAccuracy.high,
          forceLocationManager: true,
          timeLimit: const Duration(seconds: 35),
        ),
      );
    }
  }

  UserLocation _toUserLocation(Position position) =>
      UserLocation(latitude: position.latitude, longitude: position.longitude);

  @override
  Future<bool> openLocationSettings() => Geolocator.openLocationSettings();

  @override
  Future<bool> openAppSettings() => Geolocator.openAppSettings();
}
