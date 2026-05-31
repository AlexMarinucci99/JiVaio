import 'package:flutter/material.dart';

import 'data/repositories/auth_repository.dart';
import 'data/services/auth_service.dart';
import 'routing/app_routes.dart';
import 'routing/auth_gate.dart';
import 'ui/auth/widgets/reset_password_screen.dart';
import 'ui/core/themes/app_theme.dart';
import 'ui/onboarding/widgets/onboarding_screen.dart';

class JiVaioApp extends StatelessWidget {
  JiVaioApp({super.key, required this.showOnboarding});

  final bool showOnboarding;

  final AuthRepository _authRepository = AuthRepository(AuthService());

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JiVaio',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: showOnboarding
          ? AppRoutes.onboarding
          : AppRoutes.authChoice,
      routes: {
        AppRoutes.onboarding: (_) => const OnboardingScreen(),

        AppRoutes.authChoice: (_) => AuthGate(authRepository: _authRepository),

        // Route mantenuta per compatibilità.
        // Il flusso principale passa da AuthGate.
        AppRoutes.home: (_) => AuthGate(authRepository: _authRepository),

        AppRoutes.resetPassword: (_) => ResetPasswordScreen(
         authRepository: _authRepository,
        ),
      },
    );
  }
}
