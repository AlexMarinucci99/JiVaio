import 'package:flutter/material.dart';

import '../theme/route_results_colors.dart';

/// Pulsante inferiore della schermata dei risultati.
///
/// In questa fase non avvia ancora una navigazione reale.
/// La callback verrà usata dalla schermata per mostrare un feedback provvisorio.
class RouteNavigationButton extends StatelessWidget {
  const RouteNavigationButton({
    super.key,
    required this.colors,
    required this.onPressed,
  });

  final RouteResultsColors colors;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: colors.accentColor,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(58),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        icon: const Icon(Icons.navigation_rounded, size: 20),
        label: Text(
          'Inizia navigazione percorso consigliato',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            height: 1.15,
          ),
        ),
      ),
    );
  }
}
