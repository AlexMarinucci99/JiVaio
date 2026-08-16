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
    final textTheme = Theme.of(context).textTheme;

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
              style: textTheme.titleMedium?.copyWith(
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
                _buildSection(
                  textTheme,
                  title: 'Partenza',
                  description: departureDescription,
                ),
                _buildSection(
                  textTheme,
                  title: 'Fermata iniziale',
                  description: boardingStopDescription,
                ),
                _buildSection(
                  textTheme,
                  title: 'Linea consigliata',
                  description: recommendedLineDescription,
                ),
                _buildSection(
                  textTheme,
                  title: 'Durata stimata',
                  description: durationDescription,
                ),
                _buildSection(
                  textTheme,
                  title: 'Arrivo',
                  description: arrivalDescription,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    TextTheme textTheme, {
    required String title,
    required String description,
  }) {
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
            style: textTheme.bodyMedium?.copyWith(
              color: colors.textPrimaryColor,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            description,
            style: textTheme.bodyMedium?.copyWith(
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
