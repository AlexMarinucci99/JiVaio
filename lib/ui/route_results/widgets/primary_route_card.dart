import 'package:flutter/material.dart';

import '../../../domain/models/route_result.dart';
import '../theme/route_results_colors.dart';

/// Mostra il percorso consigliato in forma semplificata.
///
/// La card mantiene una suddivisione in sezioni, ma sostituisce i
/// dettagli operativi del mock con descrizioni sintetiche, più coerenti
/// con lo stato attuale del progetto.
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _PrimaryRouteHeader(colors: colors),
          Divider(height: 1, color: colors.borderColor),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
            child: Column(
              children: [
                _PrimaryRouteSection(
                  title: 'Partenza',
                  description: result.origin,
                  colors: colors,
                ),
                const SizedBox(height: 12),
                _PrimaryRouteSection(
                  title: 'Fermata iniziale',
                  description: 'Fermata X.',
                  colors: colors,
                ),
                const SizedBox(height: 12),
                _PrimaryRouteSection(
                  title: 'Linea consigliata',
                  description: 'Nav. Y.',
                  colors: colors,
                ),
                const SizedBox(height: 12),
                _PrimaryRouteSection(
                  title: 'Arrivo',
                  description: result.destination,
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

class _PrimaryRouteHeader extends StatelessWidget {
  const _PrimaryRouteHeader({required this.colors});

  final RouteResultsColors colors;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
      child: Text(
        'Percorso consigliato',
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: colors.textPrimaryColor,
          fontWeight: FontWeight.w800,
        ),
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
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
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
