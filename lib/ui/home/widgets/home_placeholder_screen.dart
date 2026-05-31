import 'dart:async';

import 'package:flutter/material.dart';

import '../../../data/repositories/transit_repository.dart';
import '../view_model/home_map_view_model.dart';
import 'home_map.dart';
import 'route_search_card.dart';

class HomePlaceholderScreen extends StatefulWidget {
  const HomePlaceholderScreen({
    super.key,
    required this.repository,
  });

  final TransitRepository repository;

  @override
  State<HomePlaceholderScreen> createState() =>
      _HomePlaceholderScreenState();
}

class _HomePlaceholderScreenState extends State<HomePlaceholderScreen> {
  static const _HomePlaceholderColors _colors = _HomePlaceholderColors();

  late final HomeMapViewModel _viewModel;

  @override
  void initState() {
    super.initState();

    _viewModel = HomeMapViewModel(repository: widget.repository);
    unawaited(_loadStops());
  }

  Future<void> _loadStops() async {
    await _viewModel.loadStops();

    if (!mounted || _viewModel.errorMessage == null) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: _colors.snackBarBackgroundColor,
        content: Text(
          _viewModel.errorMessage!,
          style: TextStyle(color: _colors.snackBarTextColor),
        ),
      ),
    );
  }

  @override
  void dispose() {
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
            // Mappa a tutto schermo con fermate GTFS.
            Positioned.fill(
              child: HomeMap(
                stops: _viewModel.stops,
                colors: _colors.mapColors,
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
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor:
                              _colors.snackBarBackgroundColor,
                          content: Text(
                            'Ricerca UI: $origin → $destination. '
                            'Logica percorso non collegata.',
                            style: TextStyle(
                              color: _colors.snackBarTextColor,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
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