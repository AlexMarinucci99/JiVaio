import 'package:flutter/material.dart';

import '../theme/route_results_colors.dart';

/// Card che mostra gli orari delle prossime navette disponibili
/// presso la fermata iniziale.
///
/// Gli orari vengono ricevuti dall'esterno.
/// Il widget non esegue calcoli e non accede al data layer.
class NextBusCard extends StatelessWidget {
  const NextBusCard({super.key, required this.times, required this.colors});

  final List<String> times;
  final RouteResultsColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
      decoration: BoxDecoration(
        color: colors.surfaceColor,
        borderRadius: BorderRadius.circular(20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Prossime navette alla fermata',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: colors.textMutedColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          if (times.isEmpty)
            Text(
              'Nessuna navetta disponibile',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colors.textSecondaryColor,
              ),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final time in times)
                  _ShuttleTimeChip(time: time, colors: colors),
              ],
            ),
        ],
      ),
    );
  }
}

class _ShuttleTimeChip extends StatelessWidget {
  const _ShuttleTimeChip({required this.time, required this.colors});

  final String time;
  final RouteResultsColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: colors.accentSoftColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: colors.accentBorderColor),
      ),
      child: Text(
        time,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: colors.accentColor,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
