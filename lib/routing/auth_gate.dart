import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../data/repositories/auth_repository.dart';
import '../ui/auth/widgets/auth_choice_screen.dart';
import '../ui/main_navigation/widgets/main_navigation_screen.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key, required this.authRepository});

  final AuthRepository authRepository;

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool _isGuest = false;

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
    await widget.authRepository.logout();
  }

  @override
  Widget build(BuildContext context) {
    if (_isGuest) {
      return MainNavigationScreen(
        isGuest: true,
        userId: null,
        onLogout: _exitGuestMode,
      );
    }

    return StreamBuilder<User?>(
      stream: widget.authRepository.authStateChanges,
      initialData: widget.authRepository.currentUser,
      builder: (context, snapshot) {
        final user = snapshot.data;

        if (user != null) {
          return MainNavigationScreen(
            isGuest: false,
            userId: user.uid,
            onLogout: _logout,
          );
        }

        return AuthChoiceScreen(
          authRepository: widget.authRepository,
          onContinueAsGuest: _continueAsGuest,
        );
      },
    );
  }
}
