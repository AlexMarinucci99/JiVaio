import 'package:flutter/material.dart';

import '../../../config/app_dependencies.dart';
import '../../../domain/models/app_user.dart';
import '../../home/widgets/home_screen.dart';
import '../../lines/widgets/lines_screen.dart';
import '../../settings/widgets/settings_screen.dart';
import 'bottom_nav_bar.dart';

/// Schermata principale mostrata dopo login, registrazione o accesso guest.
///
/// Contiene le sezioni principali dell'app e coordina la navigazione
/// tramite la barra inferiore.
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({
    super.key,
    required this.user,
    required this.onLogout,
    required this.dependencies,
  });

  /// Utente autenticato corrente.
  ///
  /// Il valore è null quando l'app viene utilizzata in modalità guest.
  final AppUser? user;

  /// Restituisce true quando l'app è usata in modalità guest.
  bool get isGuest => user == null;

  /// Azione eseguita quando l'utente esce dalla sessione corrente.
  ///
  /// Per un utente autenticato esegue il logout, mentre per un guest
  /// termina la modalità ospite.
  final Future<void> Function() onLogout;

  /// Dipendenze condivise dalle sezioni principali dell'app.
  final AppDependencies dependencies;

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  List<Widget> get _pages {
    return [
      HomeScreen(
        key: const PageStorageKey<String>('home-screen'),
        repository: widget.dependencies.transitRepository,
        locationRepository: widget.dependencies.locationRepository,
        notificationRepository: widget.dependencies.notificationRepository,
        routePlanningRepository: widget.dependencies.routePlanningRepository,
      ),
      LinesScreen(
        key: const PageStorageKey<String>('lines-screen'),
        isGuest: widget.isGuest,
        userId: widget.user?.id,
        repository: widget.dependencies.transitRepository,
        savedLinesRepository: widget.dependencies.savedLinesRepository,
      ),
      SettingsScreen(
        key: const PageStorageKey<String>('settings-screen'),
        user: widget.user,
        onLogout: widget.onLogout,
      ),
    ];
  }

  void _onItemSelected(int index) {
    if (_selectedIndex == index) return;

    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: BottomNavBar(
          selectedIndex: _selectedIndex,
          onItemSelected: _onItemSelected,
        ),
      ),
    );
  }
}
