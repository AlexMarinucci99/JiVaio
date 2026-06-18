import '../../domain/models/location_access_result.dart';
import '../../domain/models/user_location.dart';

/// Contratto per le sorgenti dati della posizione utente.
///
/// Permette al repository di non dipendere direttamente dal plugin
/// usato per permessi, impostazioni e coordinate GPS.
abstract class LocationService {
  Future<LocationAccessResult> ensureLocationAccess();

  Future<UserLocation> getCurrentLocation();

  Future<bool> openLocationSettings();

  Future<bool> openAppSettings();
}
