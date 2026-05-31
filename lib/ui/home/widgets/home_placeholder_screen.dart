import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../data/repositories/location_repository.dart';
import '../../../data/repositories/transit_repository.dart';
import '../../../domain/models/location_access_result.dart';
import '../view_model/home_map_view_model.dart';
import 'home_map.dart';
import 'locate_user_button.dart';
import 'route_search_card.dart';

class HomePlaceholderScreen extends StatefulWidget {
  const HomePlaceholderScreen({
    super.key,
    required this.repository,
    required this.locationRepository,
  });

  final TransitRepository repository;
  final LocationRepository locationRepository;

  @override
  State<HomePlaceholderScreen> createState() => _HomePlaceholderScreenState();
}

class _HomePlaceholderScreenState extends State<HomePlaceholderScreen>
    with WidgetsBindingObserver {
  static const _HomePlaceholderColors _colors = _HomePlaceholderColors();

  late final HomeMapViewModel _viewModel;

  final MapController _mapController = MapController();

  bool _isMapReady = false;

  // Diventa true quando apriamo le impostazioni native.
  // Al ritorno in app viene eseguito un nuovo controllo del GPS.
  bool _retryLocationWhenResumed = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    _viewModel = HomeMapViewModel(
      repository: widget.repository,
      locationRepository: widget.locationRepository,
    );

    unawaited(_loadStops());

    // Il dialog può essere mostrato soltanto dopo il primo frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      unawaited(_locateUser());
    });
  }

  Future<void> _loadStops() async {
    await _viewModel.loadStops();

    if (!mounted || _viewModel.errorMessage == null) {
      return;
    }

    _showSnackBar(_viewModel.errorMessage!);
  }

  Future<void> _locateUser() async {
    final result = await _viewModel.locateUser();

    if (!mounted) {
      return;
    }

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

    if (!_isMapReady || userLocation == null) {
      return;
    }

    _mapController.move(
      LatLng(userLocation.latitude, userLocation.longitude),
      16,
    );
  }

  Future<void> _showLocationServiceDialog() async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Attiva la geolocalizzazione'),
          content: const Text(
            'Per mostrarti sulla mappa, JiVaio ha bisogno che '
            'la geolocalizzazione del dispositivo sia attiva.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
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
        );
      },
    );
  }

  Future<void> _showPermissionDeniedForeverDialog() async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Permesso necessario'),
          content: const Text(
            'Il permesso di geolocalizzazione è stato bloccato. '
            'Apri le impostazioni dell’app e abilitalo manualmente.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
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
        );
      },
    );
  }

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

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

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
    _viewModel.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _viewModel,
      builder: (context, child) {
        return Stack(
          children: [
            // Mappa a tutto schermo con fermate GTFS e posizione utente.
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

            // Sfumatura superiore per rendere leggibile la card.
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

            // Card ricerca percorso sopra la mappa.
            SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 92, 18, 0),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: RouteSearchCard(
                    colors: _colors.routeSearchCardColors,
                    onSearch: (origin, destination) {
                      _showSnackBar(
                        'Ricerca UI: $origin → $destination. '
                        'Logica percorso non collegata.',
                      );
                    },
                  ),
                ),
              ),
            ),

            // Pulsante GPS sopra la navbar flottante.
            Positioned(
              right: 18,
              bottom: 104,
              child: SafeArea(
                top: false,
                child: LocateUserButton(
                  isLoading: _viewModel.isLocating,
                  colors: _colors.locateUserButtonColors,
                  onPressed: () {
                    unawaited(_locateUser());
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// Palette privata della schermata Home.
class _HomePlaceholderColors {
  const _HomePlaceholderColors();

  final Color overlayColorStrong = const Color(0x8F0B0F3A);
  final Color overlayColorSoft = const Color(0x330B0F3A);
  final Color overlayColorTransparent = Colors.transparent;

  final Color snackBarBackgroundColor = const Color(0xFF061A3A);
  final Color snackBarTextColor = Colors.white;

  final HomeMapColors mapColors = const HomeMapColors(
    fallbackBackgroundColor: Color(0xFFF7F9FC),
    stopMarkerColor: Color(0xFF0B7A55),
    stopMarkerBorderColor: Colors.white,
    userLocationHaloColor: Color(0x332D7FF9),
    userLocationMarkerColor: Color(0xFF2D7FF9),
    userLocationMarkerBorderColor: Colors.white,
  );

  final LocateUserButtonColors locateUserButtonColors =
      const LocateUserButtonColors(
        backgroundColor: Colors.white,
        iconColor: Color(0xFF17226B),
        progressColor: Color(0xFF17226B),
        shadowColor: Color(0x26000000),
      );

  final RouteSearchCardColors routeSearchCardColors =
      const RouteSearchCardColors(
        cardColor: Colors.white,
        textColor: Color(0xFF20232D),
        labelColor: Color(0xFF5C5F6D),
        dividerColor: Color(0xFFE7E8EE),
        activeButtonColor: Color(0xFF17226B),
        activeButtonTextColor: Colors.white,
        inactiveButtonColor: Color(0xFFE9E7F0),
        inactiveTextColor: Color(0xFF4F4D59),
        iconBackgroundColor: Color(0xFFF0F1F6),
        iconColor: Color(0xFF59609A),
        swapIconColor: Color(0xFF59609A),
        hintColor: Color(0xFF777986),
        shadowColor: Color(0x1F000000),
      );
}
