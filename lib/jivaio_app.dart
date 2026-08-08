import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'config/app_dependencies.dart';
import 'routing/app_routes.dart';
import 'routing/auth_gate.dart';
import 'ui/auth/view_model/auth_view_model.dart';
import 'ui/auth/view_model/reset_password_view_model.dart';
import 'ui/auth/view_model/session_view_model.dart';
import 'ui/auth/widgets/reset_password_screen.dart';
import 'ui/core/themes/app_theme.dart';
import 'ui/onboarding/view_model/onboarding_view_model.dart';
import 'ui/onboarding/widgets/onboarding_screen.dart';

/// Configura tema, route e dipendenze di JiVaio.
class JiVaioApp extends StatelessWidget {
  const JiVaioApp({
    super.key,
    required this.showOnboarding,
    required this.dependencies,
  });

  final bool showOnboarding;
  final AppDependencies dependencies;

  Widget _buildAuthGate(BuildContext context) => MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => SessionViewModel(repository: context.read()),
      ),
      ChangeNotifierProvider(
        create: (context) => AuthViewModel(context.read()),
      ),
    ],
    child: const AuthGate(),
  );

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider.value(value: dependencies.authRepository),
        Provider.value(value: dependencies.transitRepository),
        Provider.value(value: dependencies.locationRepository),
        Provider.value(value: dependencies.notificationRepository),
        Provider.value(value: dependencies.savedLinesRepository),
        Provider.value(value: dependencies.routePlanningRepository),
        Provider.value(value: dependencies.onboardingRepository),
      ],
      child: MaterialApp(
        title: 'JiVaio',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        initialRoute: showOnboarding
            ? AppRoutes.onboarding
            : AppRoutes.authChoice,
        routes: {
          AppRoutes.onboarding: (context) =>
              ChangeNotifierProvider<OnboardingViewModel>(
                create: (context) =>
                    OnboardingViewModel(onboardingRepository: context.read()),
                child: const OnboardingScreen(),
              ),
          AppRoutes.authChoice: _buildAuthGate,
          AppRoutes.home: _buildAuthGate,
          AppRoutes.resetPassword: (context) =>
              ChangeNotifierProvider<ResetPasswordViewModel>(
                create: (context) => ResetPasswordViewModel(context.read()),
                child: const ResetPasswordScreen(),
              ),
        },
      ),
    );
  }
}
