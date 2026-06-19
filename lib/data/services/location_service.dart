import '../../domain/models/location_access_result.dart';
import '../../domain/models/user_location.dart';

/// Definisce il contratto per le sorgenti dati della posizione utente.
///
/// Il repository dipende da questa astrazione invece che dal plugin concreto,
/// così permessi, impostazioni e coordinate GPS restano sostituibili.
abstract class LocationService {
  /// Verifica che il servizio di localizzazione sia disponibile e autorizzato.
  Future<LocationAccessResult> ensureLocationAccess();

  /// Restituisce la posizione corrente dell'utente.
  Future<UserLocation> getCurrentLocation();

  /// Apre le impostazioni di localizzazione del dispositivo.
  Future<bool> openLocationSettings();

  /// Apre le impostazioni dell'app sul dispositivo.
  Future<bool> openAppSettings();
}
