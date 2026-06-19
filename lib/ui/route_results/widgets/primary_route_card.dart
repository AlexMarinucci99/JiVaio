import 'package:flutter/material.dart';

import '../../../domain/models/route_result.dart';
import '../theme/route_results_colors.dart';

/// Card principale con il percorso suggerito.
///
/// La card compone il titolo, la durata totale e la timeline.
/// Non accede direttamente al ViewModel o al data layer.
class PrimaryRouteCard extends StatelessWidget {
  const PrimaryRouteCard({
    super.key,
    required this.result,
    required this.colors,
  });

  final RouteResult result;
  final RouteResultsColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colors.surfaceColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: colors.borderColor),
        boxShadow: [
          BoxShadow(
            color: colors.shadowColor,
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 18, 16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Percorso consigliato',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: colors.textPrimaryColor,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                _TotalDurationBadge(
                  duration: result.totalDuration,
                  colors: colors,
                ),
              ],
            ),
          ),
          Divider(height: 1, color: colors.borderColor),
          Padding(padding: const EdgeInsets.fromLTRB(18, 20, 18, 20)),
        ],
      ),
    );
  }
}

class _TotalDurationBadge extends StatelessWidget {
  const _TotalDurationBadge({required this.duration, required this.colors});

  final Duration duration;
  final RouteResultsColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
      decoration: BoxDecoration(
        color: colors.accentSoftColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colors.accentBorderColor),
      ),
      child: Text(
        '${duration.inMinutes} min',
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: colors.accentColor,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
