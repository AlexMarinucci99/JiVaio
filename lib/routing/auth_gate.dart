import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../domain/models/app_user.dart';
import '../ui/auth/view_model/session_view_model.dart';
import '../ui/auth/widgets/auth_choice_screen.dart';
import '../ui/home/view_model/home_map_view_model.dart';
import '../ui/lines/view_model/lines_view_model.dart';
import '../ui/main_navigation/widgets/main_navigation_screen.dart';
import '../ui/notifications/view_model/notification_center_view_model.dart';

/// Mostra autenticazione o contenuto principale in base alla sessione.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  Widget _buildMainNavigation({
    required AppUser? user,
    required Future<void> Function() onLogout,
  }) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => HomeMapViewModel(
            repository: context.read(),
            locationRepository: context.read(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              NotificationCenterViewModel(repository: context.read())
                ..loadNotifications(),
        ),
        ChangeNotifierProvider(
          create: (context) => LinesViewModel(
            transitRepository: context.read(),
            savedLinesRepository: context.read(),
            userId: user?.id,
          )..loadLines(),
        ),
      ],
      child: MainNavigationScreen(user: user, onLogout: onLogout),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SessionViewModel>();

    if (viewModel.isGuest) {
      return _buildMainNavigation(
        user: null,
        onLogout: viewModel.exitGuestMode,
      );
    }

    final user = viewModel.user;
    if (user != null) {
      return _buildMainNavigation(user: user, onLogout: viewModel.logout);
    }

    return AuthChoiceScreen(onContinueAsGuest: viewModel.continueAsGuest);
  }
}
