import 'package:flutter/material.dart';

import '../../../domain/models/route_result.dart';
import '../theme/route_results_colors.dart';

/// Card sintetica di una linea alternativa rispetto al percorso principale.
///
/// Il widget riceve i dati dall'esterno e non esegue logica di calcolo.
/// La callback [onDetails] verrà collegata in futuro alla schermata di dettaglio.
class AlternativeRouteCard extends StatelessWidget {
  const AlternativeRouteCard({
    super.key,
    required this.route,
    required this.colors,
    required this.onDetails,
  });

  /// Percorso alternativo mostrato nella card.
  final AlternativeRoute route;

  final RouteResultsColors colors;

  /// Callback eseguita quando l'utente richiede i dettagli del percorso.
  final VoidCallback onDetails;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colors.surfaceColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.borderColor),
        boxShadow: [
          BoxShadow(
            color: colors.shadowColor,
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: colors.accentColor, width: 4),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _AlternativeRouteHeader(route: route, colors: colors),
                const SizedBox(height: 14),
                _AlternativeRouteFooter(
                  route: route,
                  colors: colors,
                  onDetails: onDetails,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AlternativeRouteHeader extends StatelessWidget {
  const _AlternativeRouteHeader({required this.route, required this.colors});

  final AlternativeRoute route;
  final RouteResultsColors colors;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _LineBadge(lineCode: route.lineCode, colors: colors),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            route.description,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: colors.textPrimaryColor,
              fontWeight: FontWeight.w800,
              height: 1.25,
            ),
          ),
        ),
        const SizedBox(width: 10),
        _DurationLabel(duration: route.duration, colors: colors),
      ],
    );
  }
}

class _AlternativeRouteFooter extends StatelessWidget {
  const _AlternativeRouteFooter({
    required this.route,
    required this.colors,
    required this.onDetails,
  });

  final AlternativeRoute route;
  final RouteResultsColors colors;
  final VoidCallback onDetails;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 330;

        if (isCompact) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _TimeRangeChip(
                departureTime: route.departureTime,
                arrivalTime: route.arrivalTime,
                colors: colors,
              ),
              const SizedBox(height: 10),
              _DetailsButton(colors: colors, onDetails: onDetails),
            ],
          );
        }

        return Row(
          children: [
            Expanded(
              child: _TimeRangeChip(
                departureTime: route.departureTime,
                arrivalTime: route.arrivalTime,
                colors: colors,
              ),
            ),
            const SizedBox(width: 12),
            _DetailsButton(colors: colors, onDetails: onDetails),
          ],
        );
      },
    );
  }
}

class _LineBadge extends StatelessWidget {
  const _LineBadge({required this.lineCode, required this.colors});

  final String lineCode;
  final RouteResultsColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colors.accentColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        lineCode,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _DurationLabel extends StatelessWidget {
  const _DurationLabel({required this.duration, required this.colors});

  final Duration duration;
  final RouteResultsColors colors;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '${duration.inMinutes}',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: colors.textPrimaryColor,
              fontWeight: FontWeight.w900,
              height: 1,
            ),
          ),
          TextSpan(
            text: ' min',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: colors.textSecondaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      textAlign: TextAlign.end,
    );
  }
}

class _TimeRangeChip extends StatelessWidget {
  const _TimeRangeChip({
    required this.departureTime,
    required this.arrivalTime,
    required this.colors,
  });

  final String departureTime;
  final String arrivalTime;
  final RouteResultsColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 42),
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
      decoration: BoxDecoration(
        color: colors.accentSoftColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colors.accentBorderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.schedule_rounded, size: 17, color: colors.accentColor),
          const SizedBox(width: 7),
          Flexible(
            child: Text(
              '$departureTime → $arrivalTime',
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: colors.accentColor,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailsButton extends StatelessWidget {
  const _DetailsButton({required this.colors, required this.onDetails});

  final RouteResultsColors colors;
  final VoidCallback onDetails;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onDetails,
      style: OutlinedButton.styleFrom(
        foregroundColor: colors.accentColor,
        side: BorderSide(color: colors.accentBorderColor),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        minimumSize: const Size(104, 42),
        padding: const EdgeInsets.symmetric(horizontal: 13),
      ),
      icon: const Icon(Icons.chevron_right_rounded, size: 18),
      label: const Text('Dettagli'),
    );
  }
}
