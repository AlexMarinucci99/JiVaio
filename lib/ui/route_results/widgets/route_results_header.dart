import 'package:flutter/material.dart';

import '../../../domain/models/route_result.dart';
import '../theme/route_results_colors.dart';

/// Header superiore della schermata dei risultati.
///
/// Mostra il riepilogo della ricerca inserita dall'utente e chiarisce
/// che il calcolo reale del percorso sarà integrato successivamente.
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      decoration: BoxDecoration(
        color: colors.summaryCardBackgroundColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: colors.summaryCardBorderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SummaryLocationText(
            label: 'Partenza',
            value: result.origin,
            colors: colors,
          ),
          const SizedBox(height: 12),
          _SummaryLocationText(
            label: 'Destinazione',
            value: result.destination,
            colors: colors,
          ),
          const SizedBox(height: 16),
          Divider(height: 1, color: colors.summaryDividerColor),
          const SizedBox(height: 14),
          _SummaryDescription(colors: colors),
        ],
      ),
    );
  }
}

class _SummaryLocationText extends StatelessWidget {
  const _SummaryLocationText({
    required this.label,
    required this.value,
    required this.colors,
  });

  final String label;
  final String value;
  final RouteResultsColors colors;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: colors.headerMutedTextColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: colors.headerTextColor,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _SummaryDescription extends StatelessWidget {
  const _SummaryDescription({required this.colors});

  final RouteResultsColors colors;

  @override
  Widget build(BuildContext context) {
    return Text(
      'MINUTI STIMATI DI PERCORRENZA',
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
        color: colors.headerMutedTextColor,
        fontWeight: FontWeight.w500,
        height: 1.4,
      ),
    );
  }
}