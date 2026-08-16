import 'package:flutter/material.dart';

import '../../../domain/models/route_result.dart';
import '../theme/route_results_colors.dart';

/// Header superiore della schermata dei risultati.
///
/// Mostra il riepilogo della ricerca inserita dall'utente e mantiene
/// descrittiva la durata, senza simulare un calcolo reale del percorso.
class RouteResultsHeader extends StatelessWidget {
  const RouteResultsHeader({
    super.key,
    required this.result,
    required this.colors,
    required this.onBack,
  });

  final RouteResult result;
  final RouteResultsColors colors;

  /// Callback eseguita quando l'utente torna alla schermata precedente.
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

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
            spacing: 18,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                spacing: 14,
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
                  Expanded(
                    child: Text(
                      'Risultati percorso',
                      style: textTheme.titleLarge?.copyWith(
                        color: colors.headerTextColor,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
              _buildSummaryCard(textTheme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard(TextTheme textTheme) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 360;

        return Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(
            isCompact ? 16 : 20,
            18,
            isCompact ? 14 : 18,
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
                child: Column(
                  spacing: 14,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLocationText(
                      textTheme,
                      label: 'Partenza',
                      value: result.origin,
                    ),
                    _buildLocationText(
                      textTheme,
                      label: 'Destinazione',
                      value: result.destination,
                    ),
                  ],
                ),
              ),
              Container(
                width: 1,
                height: 108,
                margin: EdgeInsets.symmetric(horizontal: isCompact ? 12 : 16),
                color: colors.summaryDividerColor,
              ),
              SizedBox(
                width: isCompact ? 92 : 116,
                child: Text(
                  'MINUTI STIMATI\nDI PERCORRENZA',
                  textAlign: TextAlign.center,
                  style: textTheme.labelSmall?.copyWith(
                    color: colors.headerMutedTextColor,
                    fontWeight: FontWeight.w800,
                    height: 1.35,
                    letterSpacing: 0.7,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLocationText(
    TextTheme textTheme, {
    required String label,
    required String value,
  }) {
    return Column(
      spacing: 3,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.labelMedium?.copyWith(
            color: colors.headerMutedTextColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          value,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: textTheme.titleMedium?.copyWith(
            color: colors.headerTextColor,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
