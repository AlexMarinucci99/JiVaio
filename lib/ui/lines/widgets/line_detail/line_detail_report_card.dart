import 'package:flutter/material.dart';

import '../../theme/line_card_colors.dart';
import '../../theme/line_detail_colors.dart';
import '../../view_model/line_detail_view_model.dart';

part 'line_detail_report_controls.dart';

const _reportLocationOptions = [
  (
    location: LineDetailReportLocation.onBus,
    label: 'Sì',
    icon: Icons.directions_bus_rounded,
  ),
  (
    location: LineDetailReportLocation.atStop,
    label: 'No',
    icon: Icons.location_on_rounded,
  ),
];

const _reportActionOptions = [
  (
    type: LineDetailReportType.delay,
    label: 'Segnala ritardo',
    icon: Icons.schedule_rounded,
  ),
  (
    type: LineDetailReportType.crowding,
    label: 'Bus pieno',
    icon: Icons.groups_rounded,
  ),
];

/// Card per inviare segnalazioni dalla schermata dettaglio linea.
///
/// Gestisce la sola presentazione della sezione demo: posizione dell'utente,
/// istruzioni operative, pulsanti di segnalazione e feedback dell'ultima azione.
class LineDetailReportCard extends StatelessWidget {
  const LineDetailReportCard({
    super.key,
    required this.lineColor,
    required this.reportLocation,
    required this.canSendReport,
    required this.selectedStopName,
    required this.lastReportMessage,
    required this.onLocationChanged,
    required this.onReportPressed,
    this.colors = LineCardColors.defaultPalette,
  });

  final Color lineColor;

  /// Posizione dichiarata dall'utente per la segnalazione.
  ///
  /// È null finché l'utente non sceglie se si trova sulla navetta
  /// oppure alla fermata
  final LineDetailReportLocation? reportLocation;

  /// Indica se i pulsanti di segnalazione possono essere attivati.
  final bool canSendReport;

  /// Nome della fermata selezionata per la segnalazione.
  ///
  /// È null finché l'utente non seleziona una fermata dall'elenco.
  final String? selectedStopName;

  /// Messaggio mostrato dopo l'invio di una segnalazione demo.
  final String? lastReportMessage;

  /// Callback eseguita quando l'utente dichiara la propria posizione.
  final ValueChanged<LineDetailReportLocation> onLocationChanged;

  /// Callback eseguita quando l'utente invia una tipologia di segnalazione.
  final ValueChanged<LineDetailReportType> onReportPressed;

  final LineCardPalette colors;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: LineCardColors.cardDecoration(colors: colors),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Segnalazioni', style: textTheme.lineDetailCardTitle(colors)),
          const SizedBox(height: 5),
          Text(
            'Aiuta le altre persone con una segnalazione. Per ora la funzione è in modalità demo.',
            style: textTheme.lineDetailCardDescription(colors),
          ),
          const SizedBox(height: 14),
          Text(
            'Sei sulla navetta?',
            style: textTheme.labelLarge?.copyWith(
              color: colors.mutedText,
              fontSize: 10.5,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.45,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            spacing: 10,
            children: [
              for (final option in _reportLocationOptions)
                Expanded(
                  child: _LocationChoiceButton(
                    label: option.label,
                    icon: option.icon,
                    isSelected: reportLocation == option.location,
                    lineColor: lineColor,
                    colors: colors,
                    onTap: () => onLocationChanged(option.location),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          _ReportInstructionBox(
            reportLocation: reportLocation,
            canSendReport: canSendReport,
            selectedStopName: selectedStopName,
          ),
          const SizedBox(height: 12),
          Row(
            spacing: 10,
            children: [
              for (final option in _reportActionOptions)
                Expanded(
                  child: _ReportActionButton(
                    label: option.label,
                    icon: option.icon,
                    isEnabled: canSendReport,
                    lineColor: lineColor,
                    colors: colors,
                    onTap: () => onReportPressed(option.type),
                  ),
                ),
            ],
          ),
          if (lastReportMessage != null) ...[
            const SizedBox(height: 12),
            _ReportMessageBox(
              message: lastReportMessage!,
              backgroundColor: LineDetailColors.successSurface,
              textColor: LineDetailColors.successText,
            ),
          ],
        ],
      ),
    );
  }
}
