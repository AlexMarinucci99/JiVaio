import 'package:flutter/material.dart';

import '../../../domain/models/route_result.dart';
import '../../core/widgets/back_button.dart';
import '../theme/route_results_colors.dart';

/// Header superiore della schermata dei risultati.
///
/// Mostra il riepilogo della ricerca inserita dall'utente.
class RouteResultsHeader extends StatelessWidget {
  const RouteResultsHeader({
    super.key,
    required this.result,
    required this.onBack,
  });

  final RouteResult result;
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
            RouteResultsColors.headerGradientStartColor,
            RouteResultsColors.headerGradientEndColor,
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
                  AppBackButton(onPressed: onBack),
                  Expanded(
                    child: Text(
                      'Risultati percorso',
                      style: textTheme.titleLarge?.copyWith(
                        color: RouteResultsColors.headerTextColor,
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 18, 14, 18),
      decoration: BoxDecoration(
        color: RouteResultsColors.summaryCardBackgroundColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: RouteResultsColors.summaryCardBorderColor),
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
            margin: const EdgeInsets.symmetric(horizontal: 12),
            color: RouteResultsColors.summaryDividerColor,
          ),
          SizedBox(
            width: 92,
            child: Text(
              'MINUTI STIMATI\nDI PERCORRENZA',
              textAlign: TextAlign.center,
              style: textTheme.labelSmall?.copyWith(
                color: RouteResultsColors.headerMutedTextColor,
                fontWeight: FontWeight.w800,
                height: 1.35,
                letterSpacing: 0.7,
              ),
            ),
          ),
        ],
      ),
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
            color: RouteResultsColors.headerMutedTextColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          value,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: textTheme.titleMedium?.copyWith(
            color: RouteResultsColors.headerTextColor,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
