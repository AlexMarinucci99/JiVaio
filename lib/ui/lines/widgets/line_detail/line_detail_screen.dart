import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../theme/line_card_colors.dart';
import '../../theme/line_detail_colors.dart';
import '../../view_model/line_detail_view_model.dart';
import 'line_detail_departures_card.dart';
import 'line_detail_header.dart';
import 'line_detail_report_card.dart';
import 'line_detail_route_section.dart';
import 'line_detail_time_filter.dart';

/// Mostra il dettaglio della linea esposto da [LineDetailViewModel].
class LineDetailScreen extends StatelessWidget {
  const LineDetailScreen({super.key});

  Future<void> _openTimeFilterSheet(
    BuildContext context,
    LineDetailViewModel viewModel,
  ) async {
    final selection = await showLineDetailTimeFilterSheet(
      context,
      currentRangeLabel: viewModel.timeRangeLabel,
      selectedManualHour: viewModel.selectedManualHour,
      manualHours: viewModel.manualHours,
    );

    if (!context.mounted || selection == null) return;
    final selectedHour = selection.hour;
    await (selectedHour == null
        ? viewModel.selectAutomaticTime()
        : viewModel.selectManualHour(selectedHour));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LineDetailViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          backgroundColor: LineDetailColors.pageBackground,
          body: SafeArea(
            bottom: false,
            child: Column(
              children: [
                LineDetailHeader(
                  line: viewModel.line,
                  direction: viewModel.selectedDirection,
                  canSwapDirection: viewModel.canSwapDirection,
                  onSwapDirection: viewModel.toggleDirection,
                  onClose: () => Navigator.of(context).pop(),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(22, 8, 22, 120),
                    children: [
                      if (viewModel.errorMessage
                          case final String errorMessage) ...[
                        _LineDetailErrorCard(
                          message: errorMessage,
                          onRetry: viewModel.loadSchedule,
                        ),
                        const SizedBox(height: 14),
                      ],
                      LineDetailDeparturesCard(
                        selectedTimeRange: viewModel.timeRangeLabel,
                        departures: viewModel.departures,
                        selectedTripId: viewModel.selectedTripId,
                        isLoading: viewModel.isLoadingSchedule,
                        emptyMessage: viewModel.emptyDeparturesMessage,
                        onSelectTimeRange: () =>
                            _openTimeFilterSheet(context, viewModel),
                      ),
                      const SizedBox(height: 14),
                      LineDetailReportCard(
                        reportLocation: viewModel.reportLocation,
                        canSendReport: viewModel.canSendReport,
                        selectedStopName: viewModel.selectedReportStopName,
                        lastReportMessage: viewModel.lastReportMessage,
                        onLocationChanged: viewModel.selectReportLocation,
                        onReportPressed: viewModel.sendFakeReport,
                      ),
                      const SizedBox(height: 14),
                      LineDetailRouteSection(
                        stops: viewModel.stops,
                        selectedStopId: viewModel.selectedReportStopId,
                        isStopSelectionEnabled: viewModel.requiresStopSelection,
                        onStopSelected: viewModel.selectReportStop,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _LineDetailErrorCard extends StatelessWidget {
  const _LineDetailErrorCard({required this.message, required this.onRetry});

  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    const colors = LineCardColors.defaultPalette;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: LineCardColors.cardDecoration(colors: colors),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Errore caricamento dettaglio',
            style: textTheme.lineDetailCardTitle(colors),
          ),
          const SizedBox(height: 6),
          Text(message, style: textTheme.lineDetailCardDescription(colors)),
          const SizedBox(height: 12),
          FilledButton(onPressed: onRetry, child: const Text('Riprova')),
        ],
      ),
    );
  }
}
