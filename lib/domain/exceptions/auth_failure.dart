/// Tipologie di errore applicative legate all'autenticazione.
///
/// I livelli superiori non devono conoscere i codici specifici
/// restituiti da Firebase.
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
  unknown,
}

/// Errore applicativo utilizzato dal repository auth.
///
/// Traduce gli errori del provider esterno in errori
/// comprensibili dal resto dell'app.
class AuthFailure implements Exception {
  const AuthFailure(this.code);

  final AuthFailureCode code;

  @override
  String toString() {
    return 'AuthFailure(code: $code)';
  }
}
