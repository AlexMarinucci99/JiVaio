import 'package:flutter/material.dart';

import '../theme/route_results_colors.dart';

/// Mostra un riepilogo già preparato dal ViewModel.
class PrimaryRouteCard extends StatelessWidget {
  const PrimaryRouteCard({
    super.key,
    required this.departureDescription,
    required this.boardingStopDescription,
    required this.recommendedLineDescription,
    required this.durationDescription,
    required this.arrivalDescription,
    required this.colors,
  });

  final String departureDescription;
  final String boardingStopDescription;
  final String recommendedLineDescription;
  final String durationDescription;
  final String arrivalDescription;
  final RouteResultsColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colors.surfaceColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: colors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
            child: Text(
              'Percorso consigliato',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: colors.textPrimaryColor,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Divider(height: 1, color: colors.borderColor),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
            child: Column(
              spacing: 12,
              children: [
                _PrimaryRouteSection(
                  title: 'Partenza',
                  description: departureDescription,
                  colors: colors,
                ),
                _PrimaryRouteSection(
                  title: 'Fermata iniziale',
                  description: boardingStopDescription,
                  colors: colors,
                ),
                _PrimaryRouteSection(
                  title: 'Linea consigliata',
                  description: recommendedLineDescription,
                  colors: colors,
                ),
                _PrimaryRouteSection(
                  title: 'Durata stimata',
                  description: durationDescription,
                  colors: colors,
                ),
                _PrimaryRouteSection(
                  title: 'Arrivo',
                  description: arrivalDescription,
                  colors: colors,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PrimaryRouteSection extends StatelessWidget {
  const _PrimaryRouteSection({
    required this.title,
    required this.description,
    required this.colors,
  });

  final String title;
  final String description;
  final RouteResultsColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.accentSoftColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.accentBorderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colors.textPrimaryColor,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colors.textSecondaryColor,
              height: 1.4,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
