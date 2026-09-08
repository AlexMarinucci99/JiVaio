import 'package:flutter/material.dart';

import '../theme/route_results_colors.dart';

/// Pulsante inferiore della schermata dei risultati.
///
/// Attualmente mock.
class RouteNavigationButton extends StatelessWidget {
  const RouteNavigationButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: RouteResultsColors.accentColor,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(58),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      icon: const Icon(Icons.navigation_rounded, size: 20),
      label: Text(
        'Inizia navigazione percorso consigliato',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          height: 1.15,
        ),
      ),
    );
  }
}
