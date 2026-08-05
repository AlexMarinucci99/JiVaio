import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../data/repositories/location_repository.dart';
import '../../../data/repositories/notification_repository.dart';
import '../../../data/repositories/route_planning_repository.dart';
import '../../../data/repositories/transit_repository.dart';
import '../../../domain/models/location_access_result.dart';
import '../../notifications/view_model/notification_center_view_model.dart';
import '../../notifications/widgets/notification_center_overlay.dart';
import '../../route_results/widgets/route_results_screen.dart';
import '../theme/home_colors.dart';
import '../view_model/home_map_view_model.dart';
import 'home_map.dart';
import 'locate_user_button.dart';
import 'route_search_card.dart';

/// Schermata principale della Home.
///
/// Mostra la mappa, la ricerca percorso, il pulsante GPS
/// e il centro notifiche flottante.
class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.repository,
    required this.locationRepository,
    required this.notificationRepository,
    required this.routePlanningRepository,
  });

  /// Repository usato per caricare fermate e dati del trasporto urbano.
  final TransitRepository repository;

  /// Repository usato per permessi e posizione corrente dell'utente.
  final LocationRepository locationRepository;

  /// Repository usato dal centro notifiche.
  final NotificationRepository notificationRepository;

  /// Repository usato per aprire i risultati della ricerca percorso.
  final RoutePlanningRepository routePlanningRepository;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  static const HomeColors _colors = HomeColors();

  late final HomeMapViewModel _viewModel;
  late final NotificationCenterViewModel _notificationViewModel;

  // Unifica gli aggiornamenti di mappa e notifiche in un solo rebuild.
  late final Listenable _screenListenable;

  final MapController _mapController = MapController();

  bool _isMapReady = false;

  // Permette di ricontrollare il GPS dopo il ritorno dalle impostazioni native.
  bool _retryLocationWhenResumed = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    _viewModel = HomeMapViewModel(
      repository: widget.repository,
      locationRepository: widget.locationRepository,
    );

    _notificationViewModel = NotificationCenterViewModel(
      repository: widget.notificationRepository,
    );

    _screenListenable = Listenable.merge([_viewModel, _notificationViewModel]);

    unawaited(_loadStops());
    unawaited(_notificationViewModel.loadNotifications());

    // Il dialog dei permessi può essere mostrato soltanto dopo il primo frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      unawaited(_locateUser());
    });
  }

  Future<void> _loadStops() async {
    await _viewModel.loadStops();

    if (!mounted || _viewModel.errorMessage == null) return;

    _showSnackBar(_viewModel.errorMessage!);
  }

  Future<void> _locateUser() async {
    final result = await _viewModel.locateUser();

    if (!mounted) return;

    if (result == LocationAccessResult.granted) {
      _centerMapOnUser();
      return;
    }

    if (result == LocationAccessResult.serviceDisabled) {
      await _showLocationServiceDialog();
      return;
    }

    if (result == LocationAccessResult.permissionDeniedForever) {
      await _showPermissionDeniedForeverDialog();
      return;
    }

    if (result == LocationAccessResult.permissionDenied) {
      _showSnackBar(
        'Permesso di geolocalizzazione negato. '
        'Premi nuovamente il pulsante GPS per riprovare.',
      );
      return;
    }

    _showSnackBar(
      _viewModel.locationErrorMessage ??
          'Impossibile rilevare la posizione attuale.',
    );
  }

  void _centerMapOnUser() {
    final userLocation = _viewModel.userLocation;

    if (!_isMapReady || userLocation == null) return;

    _mapController.move(
      LatLng(userLocation.latitude, userLocation.longitude),
      16,
    );
  }

  Future<void> _showLocationServiceDialog() => showDialog<void>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Attiva la geolocalizzazione'),
      content: const Text(
        'Per mostrarti sulla mappa, JiVaio ha bisogno che '
        'la geolocalizzazione del dispositivo sia attiva.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(),
          child: const Text('Non ora'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(dialogContext).pop();
            _retryLocationWhenResumed = true;
            unawaited(_viewModel.openLocationSettings());
          },
          child: const Text('Apri impostazioni'),
        ),
      ],
    ),
  );

  Future<void> _showPermissionDeniedForeverDialog() => showDialog<void>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Permesso necessario'),
      content: const Text(
        'Il permesso di geolocalizzazione è stato bloccato. '
        'Apri le impostazioni dell’app e abilitalo manualmente.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(),
          child: const Text('Annulla'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(dialogContext).pop();
            _retryLocationWhenResumed = true;
            unawaited(_viewModel.openAppSettings());
          },
          child: const Text('Apri impostazioni'),
        ),
      ],
    ),
  );

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: _colors.snackBarBackgroundColor,
        content: Text(
          message,
          style: TextStyle(color: _colors.snackBarTextColor),
        ),
      ),
    );
  }

  void _openRouteResults(String origin, String destination) => unawaited(
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => RouteResultsScreen(
          repository: widget.routePlanningRepository,
          origin: origin,
          destination: destination,
        ),
      ),
    ),
  );

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state != AppLifecycleState.resumed || !_retryLocationWhenResumed) return;

    _retryLocationWhenResumed = false;

    unawaited(_locateUser());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    _mapController.dispose();
    _notificationViewModel.dispose();
    _viewModel.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _screenListenable,
      builder: (context, child) {
        return Stack(
          children: [
            Positioned.fill(
              child: HomeMap(
                mapController: _mapController,
                stops: _viewModel.stops,
                userLocation: _viewModel.userLocation,
                colors: _colors.mapColors,
                onMapReady: () {
                  _isMapReady = true;
                  _centerMapOnUser();
                },
              ),
            ),

            Positioned.fill(
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        _colors.overlayColorStrong,
                        _colors.overlayColorSoft,
                        _colors.overlayColorTransparent,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: const [0, 0.38, 0.75],
                    ),
                  ),
                ),
              ),
            ),

            SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 92, 18, 0),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: RouteSearchCard(
                    colors: _colors.routeSearchCardColors,
                    onSearch: _openRouteResults,
                  ),
                ),
              ),
            ),

            Positioned(
              right: 18,
              bottom: 104,
              child: SafeArea(
                top: false,
                child: LocateUserButton(
                  isLoading: _viewModel.isLocating,
                  colors: _colors.locateUserButtonColors,
                  onPressed: () => unawaited(_locateUser()),
                ),
              ),
            ),

            Positioned.fill(
              child: NotificationCenterOverlay(
                notifications: _notificationViewModel.notifications,
                unreadCount: _notificationViewModel.unreadCount,
                isLoading: _notificationViewModel.isLoading,
                isPanelOpen: _notificationViewModel.isPanelOpen,
                errorMessage: _notificationViewModel.errorMessage,
                onTogglePanel: _notificationViewModel.togglePanel,
                onClosePanel: _notificationViewModel.closePanel,
                onMarkAllAsRead: _notificationViewModel.markAllAsRead,
                onNotificationTap: _notificationViewModel.markAsRead,
              ),
            ),
          ],
        );
      },
    );
  }
}
