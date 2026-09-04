/// Tipologie di errore legate all'autenticazione.
enum AuthFailureCode {
  invalidEmail,
  userNotFound,
  wrongPassword,
  emailAlreadyInUse,
  weakPassword,
  networkRequestFailed,
  invalidCredential,
  tooManyRequests,
  userDisabled,
  operationNotAllowed,
  cancelled,
  unknown,
}

/// Errore applicativo utilizzato dal repository di autenticazione.
///
/// Traduce gli errori del provider esterno in errori
/// comprensibili dal resto dell'app.
class AuthFailure implements Exception {
  const AuthFailure(this.code);

  final AuthFailureCode code;

  @override
  String toString() => 'AuthFailure(code: $code)';
}
