import '../../domain/models/location_access_result.dart';
import '../../domain/models/user_location.dart';
import '../services/location_service.dart';

/// Espone al ViewModel un'API pulita per la posizione utente.
///
/// Il repository dipende da [LocationService], non dal plugin concreto.
class LocationRepository {
  const LocationRepository({required LocationService service})
    : _service = service;

  final LocationService _service;

  Future<LocationAccessResult> ensureLocationAccess() {
    return _service.ensureLocationAccess();
  }

  Future<UserLocation> getCurrentLocation() {
    return _service.getCurrentLocation();
  }

  Future<bool> openLocationSettings() {
    return _service.openLocationSettings();
  }

  Future<bool> openAppSettings() {
    return _service.openAppSettings();
  }
}
