import '../../domain/models/location_access_result.dart';
import '../../domain/models/user_location.dart';
import '../services/location_service.dart';

/// Gestisce l'accesso ai dati relativi alla posizione utente.
///
/// Espone ai ViewModel un'API stabile e indipendente
/// dall'implementazione concreta di [LocationService].
class LocationRepository {
  const LocationRepository({required LocationService service})
    : _service = service;

  final LocationService _service;

  Future<LocationAccessResult> ensureLocationAccess() =>
      _service.ensureLocationAccess();

  Future<UserLocation> getCurrentLocation() => _service.getCurrentLocation();

  Future<bool> openLocationSettings() => _service.openLocationSettings();

  Future<bool> openAppSettings() => _service.openAppSettings();
}
