import 'package:flutter/material.dart';

import '../../../../data/repositories/transit_repository.dart';
import '../../../../domain/models/transit_line.dart';
import '../../view_model/line_detail_view_model.dart';
import '../line_card/line_card_colors.dart';
import 'line_detail_colors.dart';
import 'line_detail_departures_card.dart';
import 'line_detail_header.dart';
import 'line_detail_report_card.dart';
import 'line_detail_route_section.dart';
import 'line_detail_time_filter.dart';

class LineDetailScreen extends StatefulWidget {
  const LineDetailScreen({super.key, required this.line, this.repository});

  final TransitLine line;
  final TransitRepository? repository;

  @override
  State<LineDetailScreen> createState() => _LineDetailScreenState();
}

class _LineDetailScreenState extends State<LineDetailScreen> {
  late final LineDetailViewModel _viewModel;

  @override
  void initState() {
    super.initState();

    _viewModel = LineDetailViewModel(
      line: widget.line,
      repository: widget.repository,
    );

    _viewModel.loadSchedule();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  Future<void> _openTimeFilterSheet() async {
    final selection = await showLineDetailTimeFilterSheet(
      context,
      currentRangeLabel: _viewModel.timeRangeLabel,
      isAutomaticSelected: _viewModel.isAutomaticTime,
      selectedManualHour: _viewModel.selectedManualHour,
      manualHours: _viewModel.manualHours,
      colors: _viewModel.colors,
    );

    if (!mounted || selection == null) {
      return;
    }

    if (selection.isAutomatic) {
      await _viewModel.selectAutomaticTime();
      return;
    }

    final selectedHour = selection.hour;

    if (selectedHour != null) {
      await _viewModel.selectManualHour(selectedHour);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _viewModel,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: LineDetailColors.pageBackground,
          body: SafeArea(
            bottom: false,
            child: Column(
              children: [
                LineDetailHeader(
                  line: _viewModel.line,
                  direction: _viewModel.selectedDirection,
                  lineColor: _viewModel.lineColor,
                  canSwapDirection: _viewModel.canSwapDirection,
                  onSwapDirection: () => _viewModel.toggleDirection(),
                  onClose: () => Navigator.of(context).pop(),
                  colors: _viewModel.colors,
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(22, 8, 22, 120),
                    children: [
                      if (_viewModel.errorMessage != null) ...[
                        _LineDetailErrorCard(
                          message: _viewModel.errorMessage!,
                          onRetry: _viewModel.loadSchedule,
                          colors: _viewModel.colors,
                        ),
                        const SizedBox(height: 14),
                      ],
                      LineDetailDeparturesCard(
                        lineColor: _viewModel.lineColor,
                        selectedTimeRange: _viewModel.timeRangeLabel,
                        departures: _viewModel.departures,
                        selectedTripId: _viewModel.selectedTripId,
                        isLoading: _viewModel.isLoadingSchedule,
                        emptyMessage: _viewModel.emptyDeparturesMessage,
                        onSelectTimeRange: _openTimeFilterSheet,
                        colors: _viewModel.colors,
                      ),
                      const SizedBox(height: 14),
                      LineDetailReportCard(
                        lineColor: _viewModel.lineColor,
                        reportLocation: _viewModel.reportLocation,
                        requiresStopSelection: _viewModel.requiresStopSelection,
                        canSendReport: _viewModel.canSendReport,
                        selectedStopName: _viewModel.selectedReportStopName,
                        lastReportMessage: _viewModel.lastReportMessage,
                        onLocationChanged: _viewModel.selectReportLocation,
                        onReportPressed: _viewModel.sendFakeReport,
                        colors: _viewModel.colors,
                      ),
                      const SizedBox(height: 14),
                      LineDetailRouteSection(
                        stops: _viewModel.stops,
                        lineColor: _viewModel.lineColor,
                        selectedStopId: _viewModel.selectedReportStopId,
                        isStopSelectionEnabled:
                            _viewModel.requiresStopSelection,
                        onStopSelected: _viewModel.selectReportStop,
                        colors: _viewModel.colors,
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
  const _LineDetailErrorCard({
    required this.message,
    required this.onRetry,
    required this.colors,
  });

  final String message;
  final Future<void> Function() onRetry;
  final LineCardPalette colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: LineCardColors.cardDecoration(colors: colors),
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Errore caricamento dettaglio',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: colors.primaryText,
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            message,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: colors.secondaryText,
              fontSize: 12,
              height: 1.35,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          FilledButton(onPressed: onRetry, child: const Text('Riprova')),
        ],
      ),
    );
  }
}
