import 'package:flutter/material.dart';

import '../../theme/line_card_colors.dart';
import '../../theme/line_detail_colors.dart';

part 'line_detail_time_filter_controls.dart';

/// Risultato della selezione della fascia oraria nel dettaglio linea.
///
/// Può rappresentare la modalità automatica basata sull'ora locale
/// oppure una fascia manuale scelta dall'utente.
class LineDetailTimeSelection {
  /// Crea una selezione automatica basata sull'ora locale del dispositivo.
  const LineDetailTimeSelection.automatic() : hour = null;

  /// Crea una selezione manuale per la fascia che inizia da [selectedHour].
  const LineDetailTimeSelection.manual(int selectedHour) : hour = selectedHour;

  /// Ora iniziale della fascia manuale.
  ///
  /// È null quando la selezione usa automaticamente l'ora locale.
  final int? hour;
}

/// Mostra la bottom sheet per scegliere la fascia oraria del dettaglio linea.
///
/// Restituisce una [LineDetailTimeSelection] quando l'utente conferma,
/// oppure null quando la selezione viene annullata.
Future<LineDetailTimeSelection?> showLineDetailTimeFilterSheet(
  BuildContext context, {
  required String currentRangeLabel,
  required int? selectedManualHour,
  required List<int> manualHours,
  LineCardPalette colors = LineCardColors.defaultPalette,
}) => showModalBottomSheet<LineDetailTimeSelection>(
  context: context,
  isScrollControlled: true,
  backgroundColor: LineDetailColors.transparent,
  builder: (_) => LineDetailTimeFilterSheet(
    colors: colors,
    currentRangeLabel: currentRangeLabel,
    selectedManualHour: selectedManualHour,
    manualHours: manualHours,
  ),
);

/// Bottom sheet per selezionare la fascia oraria del dettaglio linea.
///
/// Mantiene localmente la scelta temporanea e restituisce il risultato
/// solo quando l'utente preme Conferma.
class LineDetailTimeFilterSheet extends StatefulWidget {
  const LineDetailTimeFilterSheet({
    super.key,
    required this.currentRangeLabel,
    required this.selectedManualHour,
    required this.manualHours,
    this.colors = LineCardColors.defaultPalette,
  });

  /// Etichetta della fascia oraria attualmente applicata.
  final String currentRangeLabel;

  final int? selectedManualHour;

  /// Ore disponibili per la selezione manuale.
  final List<int> manualHours;

  final LineCardPalette colors;

  @override
  State<LineDetailTimeFilterSheet> createState() =>
      _LineDetailTimeFilterSheetState();
}

class _LineDetailTimeFilterSheetState extends State<LineDetailTimeFilterSheet> {
  late int? _selectedManualHour;

  @override
  void initState() {
    super.initState();
    _selectedManualHour = widget.selectedManualHour;
  }

  void _selectHour(int? hour) {
    setState(() {
      _selectedManualHour = hour;
    });
  }

  void _confirm() {
    final selectedHour = _selectedManualHour;

    Navigator.of(context).pop(
      selectedHour == null
          ? const LineDetailTimeSelection.automatic()
          : LineDetailTimeSelection.manual(selectedHour),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = widget.colors;
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      top: false,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.76,
        ),
        decoration: const BoxDecoration(
          color: LineDetailColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              width: 52,
              height: 5,
              decoration: BoxDecoration(
                color: colors.border,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(26, 26, 26, 18),
                children: [
                  Text(
                    'Seleziona fascia oraria',
                    style: textTheme.titleLarge?.copyWith(
                      color: colors.primaryText,
                      fontSize: 21,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Scegli Automatico per usare l'ora locale del dispositivo "
                    'oppure seleziona una fascia manualmente.',
                    style: textTheme.bodyMedium?.copyWith(
                      color: colors.secondaryText,
                      fontSize: 14,
                      height: 1.45,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _AutomaticTimeOption(
                    colors: colors,
                    currentRangeLabel: widget.currentRangeLabel,
                    isSelected: _selectedManualHour == null,
                    onTap: () => _selectHour(null),
                  ),
                  const SizedBox(height: 22),
                  Text(
                    'Selezione manuale',
                    style: textTheme.labelLarge?.copyWith(
                      color: colors.mutedText,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 10),
                  for (final hour in widget.manualHours)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _ManualTimeOption(
                        colors: colors,
                        label: _rangeLabelFromHour(hour),
                        isSelected: _selectedManualHour == hour,
                        onTap: () => _selectHour(hour),
                      ),
                    ),
                ],
              ),
            ),
            _SheetActionBar(
              colors: colors,
              onCancel: () => Navigator.of(context).pop(),
              onConfirm: _confirm,
            ),
          ],
        ),
      ),
    );
  }

  static String _rangeLabelFromHour(int hour) {
    final endHour = hour + 1;

    return '${hour.toString().padLeft(2, '0')}:00 - '
        '${endHour.toString().padLeft(2, '0')}:00';
  }
}
