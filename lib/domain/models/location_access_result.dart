/// Esito della verifica di accesso alla posizioe del dispositivo.
enum LocationAccessResult {
  granted,
  serviceDisabled,
  permissionDenied,
  permissionDeniedForever,
  unavailable,
}
