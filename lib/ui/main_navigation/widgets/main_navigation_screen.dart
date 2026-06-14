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

// Schermata principale dopo login/registrazione oppure accesso guest.
// Contiene le sezioni principali dell'app e la navbar inferiore.
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({
    super.key,
    required this.isGuest,
    required this.userId,
    required this.onLogout,
    required this.transitRepository,
    required this.locationRepository,
    required this.notificationRepository,
    required this.savedLinesRepository,
    required this.routePlanningRepository,
  }) : assert(isGuest || userId != null);

  // true = utente ospite
  // false = utente autenticato con Firebase
  final bool isGuest;

  // UID Firebase dell'utente autenticato.
  // È null soltanto in modalità guest.
  final String? userId;

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
  static const _MainShellColors _colors = _MainShellColors();

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
        userId: widget.userId,
        repository: widget.transitRepository,
        savedLinesRepository: widget.savedLinesRepository,
      ),
      SettingsScreen(
        key: const PageStorageKey<String>('settings-screen'),
        isGuest: widget.isGuest,
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

// Palette privata della shell principale.
// Qui si decide l'aspetto della navbar dentro la schermata principale.
class _MainShellColors {
  const _MainShellColors();

  final BottomNavBarColors bottomNavBarColors = const BottomNavBarColors(
    backgroundColor: Colors.white,
    shadowColor: Color(0x29000000),
    selectedColor: Color(0xFF102A6B),
    unselectedColor: Color(0xFF9AA3AD),
    selectedBackgroundColor: Color(0xFFEAF2FF),
    splashColor: Color(0x14102A6B),
    highlightColor: Color(0x0A102A6B),
  );
}
