/// Esito della verifica di accesso alla posizioe del dispositivo.
enum LocationAccessResult {
  /// Il servizio di localizzazione è disponibile e autorizzato.
  granted,

  /// Il servizio di localizzazione del dispositivo è disattivato.
  serviceDisabled,

  /// Il permesso di localizzazione è stato negato.
  permissionDenied,

  /// Il permesso di localizzazione è stato negato in modo permanente.
  permissionDeniedForever,

  /// La posizione non è disponibile per un errore non classificato.
  unavailable,
}
