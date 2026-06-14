import 'package:flutter/material.dart';

import '../../../domain/models/route_result.dart';
import '../theme/route_results_colors.dart';

/// Header superiore della schermata dei risultati.
///
/// Mostra:
/// - il pulsante per tornare alla schermata precedente;
/// - il titolo della pagina;
/// - partenza, destinazione e durata complessiva del percorso.
class RouteResultsHeader extends StatelessWidget {
  const RouteResultsHeader({
    super.key,
    required this.result,
    required this.colors,
    required this.onBack,
  });

  final RouteResult result;
  final RouteResultsColors colors;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colors.headerGradientStartColor,
            colors.headerGradientEndColor,
          ],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Material(
                    color: colors.backButtonBackgroundColor,
                    shape: const CircleBorder(),
                    child: IconButton(
                      onPressed: onBack,
                      tooltip: 'Torna indietro',
                      icon: Icon(
                        Icons.arrow_back_rounded,
                        color: colors.headerTextColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      'Risultati percorso',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: colors.headerTextColor,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              _RouteSummaryCard(result: result, colors: colors),
            ],
          ),
        ),
      ),
    );
  }
}

class _RouteSummaryCard extends StatelessWidget {
  const _RouteSummaryCard({required this.result, required this.colors});

  final RouteResult result;
  final RouteResultsColors colors;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 340;

        return Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(
            isCompact ? 16 : 20,
            18,
            isCompact ? 12 : 16,
            18,
          ),
          decoration: BoxDecoration(
            color: colors.summaryCardBackgroundColor,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: colors.summaryCardBorderColor),
          ),
          child: Row(
            children: [
              Expanded(
                child: _SummaryLocations(result: result, colors: colors),
              ),
              Container(
                width: 1,
                height: 86,
                margin: EdgeInsets.symmetric(horizontal: isCompact ? 11 : 16),
                color: colors.summaryDividerColor,
              ),
              SizedBox(
                width: isCompact ? 52 : 62,
                child: _TotalDuration(
                  duration: result.totalDuration,
                  colors: colors,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SummaryLocations extends StatelessWidget {
  const _SummaryLocations({required this.result, required this.colors});

  final RouteResult result;
  final RouteResultsColors colors;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: 6,
          top: 18,
          bottom: 18,
          child: Container(width: 2, color: colors.headerMutedTextColor),
        ),
        Column(
          children: [
            _SummaryLocationRow(
              label: 'Partenza',
              value: result.origin,
              markerColor: colors.departureMarkerColor,
              colors: colors,
            ),
            const SizedBox(height: 14),
            _SummaryLocationRow(
              label: 'Arrivo',
              value: result.destination,
              markerColor: colors.arrivalMarkerColor,
              colors: colors,
            ),
          ],
        ),
      ],
    );
  }
}

class _SummaryLocationRow extends StatelessWidget {
  const _SummaryLocationRow({
    required this.label,
    required this.value,
    required this.markerColor,
    required this.colors,
  });

  final String label;
  final String value;
  final Color markerColor;
  final RouteResultsColors colors;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 14,
          height: 14,
          margin: const EdgeInsets.only(top: 3),
          decoration: BoxDecoration(
            color: markerColor,
            shape: BoxShape.circle,
            border: Border.all(color: colors.headerTextColor, width: 2),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: colors.headerMutedTextColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: colors.headerTextColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TotalDuration extends StatelessWidget {
  const _TotalDuration({required this.duration, required this.colors});

  final Duration duration;
  final RouteResultsColors colors;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '${duration.inMinutes}',
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
            color: colors.headerTextColor,
            fontWeight: FontWeight.w800,
            height: 1,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'min',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: colors.headerMutedTextColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
