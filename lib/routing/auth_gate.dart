import 'package:flutter/material.dart';

import '../config/app_dependencies.dart';
import '../data/repositories/auth_repository.dart';
import '../domain/models/app_user.dart';
import '../ui/auth/widgets/auth_choice_screen.dart';
import '../ui/main_navigation/widgets/main_navigation_screen.dart';

/// Gestisce l'accesso iniziale all'app in base allo stato di autenticazione.
///
/// Mostra la schermata principale per utenti autenticati o guest,
/// altrimenti rimanda alla scelta tra login, registrazione e accesso ospite.
class AuthGate extends StatefulWidget {
  const AuthGate({
    super.key,
    required this.dependencies,
  });

  /// Dipendenze applicative necessarie alle schermate raggiunte dal gate.
  final AppDependencies dependencies;

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool _isGuest = false;

  AuthRepository get _authRepository =>
      widget.dependencies.authRepository;

  void _continueAsGuest() =>
      setState(() => _isGuest = true);

  Future<void> _exitGuestMode() async =>
      setState(() => _isGuest = false);

  Future<void> _logout() => _authRepository.logout();

  @override
  Widget build(BuildContext context) {
    if (_isGuest) {
      return MainNavigationScreen(
        user: null,
        onLogout: _exitGuestMode,
        dependencies: widget.dependencies,
      );
    }

    return StreamBuilder<AppUser?>(
      stream: _authRepository.authStateChanges,
      initialData: _authRepository.currentUser,
      builder: (context, snapshot) {
        final user = snapshot.data;

        if (user != null) {
          return MainNavigationScreen(
            user: user,
            onLogout: _logout,
            dependencies: widget.dependencies,
          );
        }

        return AuthChoiceScreen(
          authRepository: _authRepository,
          onContinueAsGuest: _continueAsGuest,
        );
      },
    );
  }
}