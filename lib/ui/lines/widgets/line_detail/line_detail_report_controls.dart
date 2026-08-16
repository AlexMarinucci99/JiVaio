part of 'line_detail_report_card.dart';

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
    const borderRadius = BorderRadius.all(Radius.circular(16));

    return Material(
      color: LineDetailColors.transparent,
      child: InkWell(
        borderRadius: borderRadius,
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: borderRadius,
            border: Border.all(color: borderColor),
          ),
          child: Row(
            spacing: 8,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: foregroundColor, size: 18),
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
    required this.reportLocation,
    required this.canSendReport,
    required this.selectedStopName,
  });

  final LineDetailReportLocation? reportLocation;
  final bool canSendReport;
  final String? selectedStopName;

  @override
  Widget build(BuildContext context) {
    return _ReportMessageBox(
      message: _message(),
      backgroundColor: canSendReport
          ? LineDetailColors.successSurface
          : LineDetailColors.warningSurface,
      textColor: canSendReport
          ? LineDetailColors.successText
          : LineDetailColors.reportInstructionWarningText,
    );
  }

  String _message() => switch ((reportLocation, selectedStopName)) {
    (null, _) => 'Seleziona Sì o No per continuare.',
    (LineDetailReportLocation.onBus, null) =>
      'Seleziona dall’elenco fermate, la fermata in cui sei salito sul bus.',
    (LineDetailReportLocation.atStop, null) =>
      'Seleziona dall’elenco fermate, la fermata in cui ti trovi.',
    (LineDetailReportLocation.onBus, final String stopName) =>
      'Fermata di salita selezionata: $stopName.',
    (LineDetailReportLocation.atStop, final String stopName) =>
      'Fermata attuale selezionata: $stopName.',
  };
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
    final foregroundColor = LineCardColors.textOn(lineColor, colors: colors);

    return FilledButton.icon(
      onPressed: isEnabled ? onTap : null,
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(46),
        backgroundColor: lineColor,
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

class _ReportMessageBox extends StatelessWidget {
  const _ReportMessageBox({
    required this.message,
    required this.backgroundColor,
    required this.textColor,
  });

  final String message;
  final Color backgroundColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        message,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: textColor,
          fontSize: 11.8,
          height: 1.35,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
