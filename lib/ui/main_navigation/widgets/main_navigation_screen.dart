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

/// Schermata principale mostrata dopo login, registrazione o accesso guest.
///
/// Contiene le sezioni principali dell'app e coordina la navigazione
/// tramite la barra inferiore.
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

  /// Repository usato dalle schermate che leggono dati del trasporto urbano.
  final TransitRepository transitRepository;

  /// Repository usato dalla Home per posizione e permessi GPS.
  final LocationRepository locationRepository;

  /// Repository usato dalla Home per il centro notifiche.
  final NotificationRepository notificationRepository;

  /// Repository usato dalla schermata linee per i preferiti.
  final SavedLinesRepository savedLinesRepository;

  /// Repository usato dalla Home per aprire i risultati del percorso.
  final RoutePlanningRepository routePlanningRepository;

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  static const MainNavigationColors _colors = MainNavigationColors();

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

  void _onItemSelected(int index) {
    if (_selectedIndex == index) return;

    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Consente alla navbar flottante di sovrapporsi leggermente al body.
      extendBody: true,

      body: IndexedStack(index: _selectedIndex, children: _pages),

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
