import 'package:flutter/material.dart';
import '../domain/models/app_user.dart';

import '../config/app_dependencies.dart';
import '../data/repositories/auth_repository.dart';
import '../ui/auth/widgets/auth_choice_screen.dart';
import '../ui/main_navigation/widgets/main_navigation_screen.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key, required this.dependencies});

  final AppDependencies dependencies;

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool _isGuest = false;

  AuthRepository get _authRepository {
    return widget.dependencies.authRepository;
  }

  void _continueAsGuest() {
    setState(() {
      _isGuest = true;
    });
  }

  Future<void> _exitGuestMode() async {
    setState(() {
      _isGuest = false;
    });
  }

  Future<void> _logout() async {
    await _authRepository.logout();
  }

  @override
  Widget build(BuildContext context) {
    if (_isGuest) {
      return MainNavigationScreen(
        user: null,
        onLogout: _exitGuestMode,
        transitRepository: widget.dependencies.transitRepository,
        locationRepository: widget.dependencies.locationRepository,
        notificationRepository: widget.dependencies.notificationRepository,
        savedLinesRepository: widget.dependencies.savedLinesRepository,
        routePlanningRepository: widget.dependencies.routePlanningRepository,
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
            transitRepository: widget.dependencies.transitRepository,
            locationRepository: widget.dependencies.locationRepository,
            notificationRepository: widget.dependencies.notificationRepository,
            savedLinesRepository: widget.dependencies.savedLinesRepository,
            routePlanningRepository:
                widget.dependencies.routePlanningRepository,
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
