import 'package:flutter/material.dart';

import 'home_map.dart';

// Schermata Home provvisoria.
// Per ora contiene solo la mappa a tutto schermo.
class HomePlaceholderScreen extends StatelessWidget {
  const HomePlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SizedBox.expand(
        child: HomeMap(),
      ),
    );
  }
}