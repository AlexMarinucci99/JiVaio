import 'dart:async';

import 'package:jivaio/data/services/auth_service.dart';
import 'package:jivaio/domain/models/app_user.dart';

/// Registra le richieste auth senza inizializzare Firebase.
class FakeAuthService implements AuthService {
  final logins = <({String email, String password})>[];
  final registrations = <({String name, String email, String password})>[];
  final resetEmails = <String>[];
  int googleRequests = 0;
  Completer<void>? pending;
  Object? failure;

  Future<void> _complete() async {
    await pending?.future;
    if (failure != null) throw failure!;
  }

  @override
  AppUser? get currentUser => null;

  @override
  Stream<AppUser?> authStateChanges() => const Stream.empty();

  @override
  Future<void> login({required String email, required String password}) {
    logins.add((email: email, password: password));
    return _complete();
  }

  @override
  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) {
    registrations.add((name: name, email: email, password: password));
    return _complete();
  }

  @override
  Future<void> loginWithGoogle() {
    googleRequests++;
    return _complete();
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) {
    resetEmails.add(email);
    return _complete();
  }

  @override
  Future<void> logout() async {}
}
