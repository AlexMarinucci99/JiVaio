import '../../domain/models/location_access_result.dart';
import '../../domain/models/user_location.dart';

/// Definisce il contratto per le sorgenti dati della posizione utente.

abstract class LocationService {
  Future<LocationAccessResult> ensureLocationAccess();
  Future<UserLocation> getCurrentLocation();
  Future<bool> openLocationSettings();
  Future<bool> openAppPermissionSettings();
}
