import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../../../domain/models/location_access_result.dart';
import '../../notifications/widgets/notification_center_overlay.dart';
import '../../route_results/view_model/route_results_view_model.dart';
import '../../route_results/widgets/route_results_screen.dart';
import '../theme/home_colors.dart';
import '../view_model/home_map_view_model.dart';
import 'home_map.dart';
import 'locate_user_button.dart';
import 'route_search_card.dart';

/// Mostra mappa, ricerca, posizione utente e centro notifiche.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  static const HomeColors _colors = HomeColors();

  final MapController _mapController = MapController();
  HomeMapViewModel get _viewModel => context.read<HomeMapViewModel>();

  bool _isMapReady = false;
  bool _retryLocationWhenResumed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    unawaited(_loadStops());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) unawaited(_locateUser());
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
    } else if (result == LocationAccessResult.serviceDisabled) {
      await _showLocationServiceDialog();
    } else if (result == LocationAccessResult.permissionDeniedForever) {
      await _showPermissionDeniedForeverDialog();
    } else if (result == LocationAccessResult.permissionDenied) {
      _showSnackBar(
        'Permesso di geolocalizzazione negato. '
        'Premi nuovamente il pulsante GPS per riprovare.',
      );
    } else {
      _showSnackBar(
        _viewModel.locationErrorMessage ??
            'Impossibile rilevare la posizione attuale.',
      );
    }
  }

  void _centerMapOnUser() {
    final location = _viewModel.userLocation;
    if (!_isMapReady || location == null) return;

    _mapController.move(LatLng(location.latitude, location.longitude), 16);
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

  void _openRouteResults(String origin, String destination) {
    unawaited(
      Navigator.of(context).push<void>(
        MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider<RouteResultsViewModel>(
            create: (context) => RouteResultsViewModel(
              repository: context.read(),
              origin: origin,
              destination: destination,
            )..loadRoute(),
            child: const RouteResultsScreen(),
          ),
        ),
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed || !_retryLocationWhenResumed) {
      return;
    }
    _retryLocationWhenResumed = false;
    unawaited(_locateUser());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Consumer<HomeMapViewModel>(
            builder: (context, viewModel, child) => HomeMap(
              mapController: _mapController,
              stops: viewModel.stops,
              userLocation: viewModel.userLocation,
              colors: _colors.mapColors,
              onMapReady: () {
                _isMapReady = true;
                _centerMapOnUser();
              },
            ),
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
            child: Consumer<HomeMapViewModel>(
              builder: (context, viewModel, child) => LocateUserButton(
                isLoading: viewModel.isLocating,
                colors: _colors.locateUserButtonColors,
                onPressed: () => unawaited(_locateUser()),
              ),
            ),
          ),
        ),
        const Positioned.fill(child: NotificationCenterOverlay()),
      ],
    );
  }
}
