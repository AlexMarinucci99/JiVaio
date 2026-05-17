import 'package:flutter/material.dart';
import 'ui/auth/widgets/reset_password_screen.dart';
import 'routing/app_routes.dart';
import 'ui/auth/widgets/auth_choice_screen.dart';
import 'ui/auth/widgets/login_screen.dart';
import 'ui/auth/widgets/register_screen.dart';
import 'ui/core/themes/app_theme.dart';
import 'ui/onboarding/widgets/onboarding_screen.dart';
import 'ui/main_shell/widgets/main_shell_screen.dart';

class WayLineApp extends StatelessWidget {
  const WayLineApp({super.key, required this.showOnboarding});

  // true = mostra onboarding
  // false = vai direttamente a login/registrazione
  final bool showOnboarding;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WayLine',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,

      // Rotta iniziale scelta in base alla preferenza salvata.
      initialRoute: showOnboarding
          ? AppRoutes.onboarding
          : AppRoutes.authChoice,

      routes: {
        AppRoutes.onboarding: (_) => const OnboardingScreen(),
        AppRoutes.authChoice: (_) => const AuthChoiceScreen(),
        AppRoutes.login: (_) => const LoginScreen(),
        AppRoutes.register: (_) => const RegisterScreen(),

        // Schermata principale con navbar inferiore.
        AppRoutes.home: (_) => const MainShellScreen(),
        AppRoutes.resetPassword: (_) => const ResetPasswordScreen(),
      },
    );
  }
}
