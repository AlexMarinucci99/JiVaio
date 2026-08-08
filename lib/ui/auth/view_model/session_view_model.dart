import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../data/repositories/auth_repository.dart';
import '../../../domain/models/app_user.dart';

/// Gestisce lo stato della sessione autenticata o guest.
class SessionViewModel extends ChangeNotifier {
  SessionViewModel({required AuthRepository repository})
    : _repository = repository,
      _user = repository.currentUser {
    _authSubscription = _repository.authStateChanges.listen(
      _onAuthStateChanged,
    );
  }

  final AuthRepository _repository;

  late final StreamSubscription<AppUser?> _authSubscription;

  AppUser? _user;
  bool _isGuest = false;
  bool _isDisposed = false;

  AppUser? get user => _user;

  bool get isGuest => _isGuest;

  void continueAsGuest() {
    if (_isGuest) return;

    _isGuest = true;
    _notifyListenersSafely();
  }

  Future<void> exitGuestMode() async {
    if (!_isGuest) return;

    _isGuest = false;
    _notifyListenersSafely();
  }

  Future<void> logout() => _repository.logout();

  void _onAuthStateChanged(AppUser? user) {
    _user = user;

    if (user != null) {
      _isGuest = false;
    }

    _notifyListenersSafely();
  }

  void _notifyListenersSafely() {
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    unawaited(_authSubscription.cancel());
    super.dispose();
  }
}