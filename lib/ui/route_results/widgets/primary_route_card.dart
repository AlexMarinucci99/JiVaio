import 'package:flutter/material.dart';

import '../../../domain/models/route_result.dart';
import '../theme/route_results_colors.dart';

/// Mostra il percorso consigliato in forma sintetica.
///
/// La card legge i dati da [RouteResult] e mantiene la UI indipendente
/// dalla sorgente che ha prodotto il percorso.
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
                  description: _departureDescription,
                  colors: colors,
                ),
                const SizedBox(height: 12),
                _PrimaryRouteSection(
                  title: 'Fermata iniziale',
                  description: _boardingStopDescription,
                  colors: colors,
                ),
                const SizedBox(height: 12),
                _PrimaryRouteSection(
                  title: 'Linea consigliata',
                  description: _recommendedLineDescription,
                  colors: colors,
                ),
                const SizedBox(height: 12),
                _PrimaryRouteSection(
                  title: 'Durata stimata',
                  description: _formatDuration(result.totalDuration),
                  colors: colors,
                ),
                const SizedBox(height: 12),
                _PrimaryRouteSection(
                  title: 'Arrivo',
                  description: _arrivalDescription,
                  colors: colors,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String get _departureDescription {
    final departureStep = _firstStepOfType(RouteStepType.departure);
    final scheduledTime = departureStep?.scheduledTime;

    if (scheduledTime == null || scheduledTime.isEmpty) {
      return result.origin;
    }

    return '${result.origin}\nPartenza prevista: $scheduledTime';
  }

  String get _boardingStopDescription {
    final walkStep = _firstStepOfType(RouteStepType.walk);
    final subtitle = walkStep?.subtitle;

    if (subtitle == null || subtitle.isEmpty) {
      return 'Fermata non disponibile.';
    }

    return subtitle.replaceFirst(RegExp(r'^Fermata:\s*'), '');
  }

  String get _recommendedLineDescription {
    final lineCode = _firstLineCode;
    final nextBusTime = result.nextBusTimes.isEmpty
        ? null
        : result.nextBusTimes.first;

    if (lineCode == null || lineCode.isEmpty) {
      return 'Linea non disponibile.';
    }

    if (nextBusTime == null || nextBusTime.isEmpty) {
      return 'Linea $lineCode';
    }

    return 'Linea $lineCode\nProssima corsa: $nextBusTime';
  }

  String get _arrivalDescription {
    final destinationStep = _firstStepOfType(RouteStepType.destination);
    final scheduledTime = destinationStep?.scheduledTime;

    if (scheduledTime == null || scheduledTime.isEmpty) {
      return result.destination;
    }

    return '${result.destination}\nArrivo previsto: $scheduledTime';
  }

  String? get _firstLineCode {
    for (final step in result.recommendedSteps) {
      final lineCode = step.lineCode;

      if (lineCode != null && lineCode.isNotEmpty) {
        return lineCode;
      }
    }

    return null;
  }

  RouteStep? _firstStepOfType(RouteStepType type) {
    for (final step in result.recommendedSteps) {
      if (step.type == type) {
        return step;
      }
    }

    return null;
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    if (hours > 0 && minutes > 0) {
      return '$hours h $minutes min';
    }

    if (hours > 0) {
      return '$hours h';
    }

    return '$minutes min';
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