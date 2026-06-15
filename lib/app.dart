import 'package:flutter/material.dart';

import 'config/app_dependencies.dart';
import 'routing/app_routes.dart';
import 'routing/auth_gate.dart';
import 'ui/auth/widgets/reset_password_screen.dart';
import 'ui/core/themes/app_theme.dart';
import 'ui/onboarding/widgets/onboarding_screen.dart';

class JiVaioApp extends StatelessWidget {
  const JiVaioApp({
    super.key,
    required this.showOnboarding,
    required this.dependencies,
  });

  final bool showOnboarding;
  final AppDependencies dependencies;

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
        AppRoutes.onboarding: (_) => OnboardingScreen(
          onboardingRepository: dependencies.onboardingRepository,
        ),
        AppRoutes.authChoice: (_) => AuthGate(dependencies: dependencies),

        // Route mantenuta per compatibilità.
        // Il flusso principale passa da AuthGate.
        AppRoutes.home: (_) => AuthGate(dependencies: dependencies),

        AppRoutes.resetPassword: (_) =>
            ResetPasswordScreen(authRepository: dependencies.authRepository),
      },
    );
  }
}
