import 'package:flutter/material.dart';

import '../../view_model/line_detail_view_model.dart';
import '../line_card/line_card_colors.dart';
import 'line_detail_colors.dart';

class LineDetailReportCard extends StatelessWidget {
  const LineDetailReportCard({
    super.key,
    required this.lineColor,
    required this.reportLocation,
    required this.requiresStopSelection,
    required this.canSendReport,
    required this.selectedStopName,
    required this.lastReportMessage,
    required this.onLocationChanged,
    required this.onReportPressed,
    this.colors = LineCardColors.defaultPalette,
  });

  final Color lineColor;
  final LineDetailReportLocation? reportLocation;
  final bool requiresStopSelection;
  final bool canSendReport;
  final String? selectedStopName;
  final String? lastReportMessage;
  final ValueChanged<LineDetailReportLocation> onLocationChanged;
  final ValueChanged<LineDetailReportType> onReportPressed;
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
            'Segnalazioni',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: colors.primaryText,
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Aiutaci a capire lo stato della corsa. Per ora la funzione è in modalità demo.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: colors.secondaryText,
              fontSize: 12,
              height: 1.35,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Sei sulla navetta?',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: colors.mutedText,
              fontSize: 10.5,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.45,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _LocationChoiceButton(
                  label: 'Sì',
                  icon: Icons.directions_bus_rounded,
                  isSelected: reportLocation == LineDetailReportLocation.onBus,
                  lineColor: lineColor,
                  colors: colors,
                  onTap: () =>
                      onLocationChanged(LineDetailReportLocation.onBus),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _LocationChoiceButton(
                  label: 'No',
                  icon: Icons.location_on_rounded,
                  isSelected: reportLocation == LineDetailReportLocation.atStop,
                  lineColor: lineColor,
                  colors: colors,
                  onTap: () =>
                      onLocationChanged(LineDetailReportLocation.atStop),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _ReportInstructionBox(
            requiresStopSelection: requiresStopSelection,
            canSendReport: canSendReport,
            selectedStopName: selectedStopName,
            colors: colors,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _ReportActionButton(
                  label: 'Segnala ritardo',
                  icon: Icons.schedule_rounded,
                  isEnabled: canSendReport,
                  lineColor: lineColor,
                  colors: colors,
                  onTap: () => onReportPressed(LineDetailReportType.delay),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _ReportActionButton(
                  label: 'Bus pieno',
                  icon: Icons.groups_rounded,
                  isEnabled: canSendReport,
                  lineColor: lineColor,
                  colors: colors,
                  onTap: () => onReportPressed(LineDetailReportType.crowding),
                ),
              ),
            ],
          ),
          if (lastReportMessage != null) ...[
            const SizedBox(height: 12),
            _ReportFeedbackBox(message: lastReportMessage!, colors: colors),
          ],
        ],
      ),
    );
  }
}

class _LocationChoiceButton extends StatelessWidget {
  const _LocationChoiceButton({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.lineColor,
    required this.colors,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final Color lineColor;
  final LineCardPalette colors;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isSelected
        ? lineColor.withValues(alpha: 0.1)
        : LineDetailColors.softSurface;

    final borderColor = isSelected
        ? lineColor.withValues(alpha: 0.42)
        : colors.border;

    final foregroundColor = isSelected ? lineColor : colors.secondaryText;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: foregroundColor, size: 18),
              const SizedBox(width: 8),
              Text(
                label,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: foregroundColor,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReportInstructionBox extends StatelessWidget {
  const _ReportInstructionBox({
    required this.requiresStopSelection,
    required this.canSendReport,
    required this.selectedStopName,
    required this.colors,
  });

  final bool requiresStopSelection;
  final bool canSendReport;
  final String? selectedStopName;
  final LineCardPalette colors;

  @override
  Widget build(BuildContext context) {
    final message = _message();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        color: canSendReport
            ? LineDetailColors.successSurface
            : LineDetailColors.warningSurface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        message,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: canSendReport
              ? LineDetailColors.successText
              : LineDetailColors.warningText,
          fontSize: 11.8,
          height: 1.35,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  String _message() {
    if (requiresStopSelection && selectedStopName == null) {
      return 'Seleziona una fermata dal percorso completo prima di inviare la segnalazione.';
    }

    if (requiresStopSelection && selectedStopName != null) {
      return 'Fermata selezionata: $selectedStopName.';
    }

    if (canSendReport) {
      return 'Puoi inviare una segnalazione riferita alla corsa corrente selezionando la fermata dove si è nel percorso completo ';
    }

    return 'Seleziona Sì o No per continuare.';
  }
}

class _ReportActionButton extends StatelessWidget {
  const _ReportActionButton({
    required this.label,
    required this.icon,
    required this.isEnabled,
    required this.lineColor,
    required this.colors,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isEnabled;
  final Color lineColor;
  final LineCardPalette colors;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isEnabled
        ? lineColor
        : LineDetailColors.disabledSurface;

    final foregroundColor = isEnabled
        ? LineCardColors.textOn(lineColor, colors: colors)
        : LineDetailColors.disabledText;

    return FilledButton.icon(
      onPressed: isEnabled ? onTap : null,
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(46),
        backgroundColor: backgroundColor,
        disabledBackgroundColor: LineDetailColors.disabledSurface,
        foregroundColor: foregroundColor,
        disabledForegroundColor: LineDetailColors.disabledText,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
      icon: Icon(icon, size: 17),
      label: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800),
      ),
    );
  }
}

class _ReportFeedbackBox extends StatelessWidget {
  const _ReportFeedbackBox({required this.message, required this.colors});

  final String message;
  final LineCardPalette colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        color: LineDetailColors.successSurface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        message,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: LineDetailColors.successText,
          fontSize: 11.8,
          height: 1.35,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
