import 'package:flutter/material.dart';

import '../../../data/repositories/transit_repository.dart';
import '../../core/widgets/bottom_nav_bar.dart';
import '../../home/widgets/home_screen.dart';
import '../../lines/widgets/lines_screen.dart';
import '../../settings/widgets/settings_screen.dart';
import '../../../data/repositories/location_repository.dart';
import '../../../data/repositories/notification_repository.dart';
import '../../../data/repositories/saved_lines_repository.dart';
import '../../../data/repositories/route_planning_repository.dart';
import '../../../domain/models/app_user.dart';
import '../theme/main_navigation_colors.dart';

// Schermata principale dopo login/registrazione oppure accesso guest.
// Contiene le sezioni principali dell'app e la navbar inferiore.
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({
    super.key,
    required this.user,
    required this.onLogout,
    required this.transitRepository,
    required this.locationRepository,
    required this.notificationRepository,
    required this.savedLinesRepository,
    required this.routePlanningRepository,
  });

  /// Utente autenticato.
  ///
  /// Il valore è null quando l'app viene utilizzata
  /// in modalità guest.
  final AppUser? user;

  /// Restituisce true quando non è presente un utente autenticato.
  bool get isGuest => user == null;

  // Azione eseguita dalla schermata impostazioni.
  // Per utente registrato: logout Firebase.
  // Per guest: uscita dalla modalità ospite.
  final Future<void> Function() onLogout;

  final TransitRepository transitRepository;
  final LocationRepository locationRepository;
  final NotificationRepository notificationRepository;
  final SavedLinesRepository savedLinesRepository;
  final RoutePlanningRepository routePlanningRepository;

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  // Stato locale della navbar.
  int _selectedIndex = 0;

  // Colori propri della main shell.
  static const MainNavigationColors _colors = MainNavigationColors();

  // Schermate principali dell'app.
  // Non è static const perché LinesScreen e SettingsScreen
  // devono ricevere dati dinamici legati allo stato utente.
  List<Widget> get _pages {
    return [
      HomeScreen(
        key: const PageStorageKey<String>('home-screen'),
        repository: widget.transitRepository,
        locationRepository: widget.locationRepository,
        notificationRepository: widget.notificationRepository,
        routePlanningRepository: widget.routePlanningRepository,
      ),
      LinesScreen(
        key: const PageStorageKey<String>('lines-screen'),
        isGuest: widget.isGuest,
        userId: widget.user?.id,
        repository: widget.transitRepository,
        savedLinesRepository: widget.savedLinesRepository,
      ),
      SettingsScreen(
        key: const PageStorageKey<String>('settings-screen'),
        user: widget.user,
        onLogout: widget.onLogout,
      ),
    ];
  }

  // Cambio tab navbar.
  void _onItemSelected(int index) {
    if (_selectedIndex == index) return;

    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Permette alla navbar flottante di sovrapporsi leggermente al body.
      extendBody: true,

      // Cambia schermata in base al tab selezionato.
      body: IndexedStack(index: _selectedIndex, children: _pages),

      // Navbar inferiore.
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: BottomNavBar(
          selectedIndex: _selectedIndex,
          onItemSelected: _onItemSelected,
          colors: _colors.bottomNavBarColors,
        ),
      ),
    );
  }
}
