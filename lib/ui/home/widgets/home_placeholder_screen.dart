import 'package:flutter/material.dart';

import 'home_map.dart';
import 'route_search_card.dart';

class HomePlaceholderScreen extends StatelessWidget {
  const HomePlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Mappa a tutto schermo.
        const Positioned.fill(child: HomeMap()),

        // Sfumatura superiore per rendere leggibile la card.
        Positioned.fill(
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF0B0F3A).withValues(alpha: 0.56),
                    const Color(0xFF0B0F3A).withValues(alpha: 0.20),
                    Colors.transparent,
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
                onSearch: (origin, destination) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Ricerca UI: $origin → $destination. Logica percorso non collegata.',
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
