import 'package:flutter/material.dart';

import 'home_map.dart';
import 'route_search_card.dart';

class HomePlaceholderScreen extends StatelessWidget {
  const HomePlaceholderScreen({super.key});

  // Palette privata della schermata home.
  static const _HomePlaceholderColors _colors = _HomePlaceholderColors();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Mappa a tutto schermo.
        Positioned.fill(child: HomeMap(colors: _colors.mapColors)),

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
                      backgroundColor: _colors.snackBarBackgroundColor,
                      content: Text(
                        'Ricerca UI: $origin → $destination. Logica percorso non collegata.',
                        style: TextStyle(color: _colors.snackBarTextColor),
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
  }
}

// Palette privata della schermata Home.
// Qui stanno i colori specifici di questa schermata.
class _HomePlaceholderColors {
  const _HomePlaceholderColors();

  // Colori della sfumatura sopra la mappa.
  final Color overlayColorStrong = const Color(0x8F0B0F3A);
  final Color overlayColorSoft = const Color(0x330B0F3A);
  final Color overlayColorTransparent = Colors.transparent;

  // Colori dello snackbar provvisorio.
  final Color snackBarBackgroundColor = const Color(0xFF061A3A);
  final Color snackBarTextColor = Colors.white;

  // Colori della mappa.
  final HomeMapColors mapColors = const HomeMapColors(
    fallbackBackgroundColor: Color(0xFFF7F9FC),
  );

  // Colori della card ricerca percorso nella Home.
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
