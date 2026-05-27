import 'package:flutter/material.dart';

import '../line_card/line_card_colors.dart';
import 'line_detail_colors.dart';

class LineDetailTimeSelection {
  const LineDetailTimeSelection.automatic()
      : isAutomatic = true,
        hour = null;

  const LineDetailTimeSelection.manual(this.hour) : isAutomatic = false;

  final bool isAutomatic;
  final int? hour;
}

Future<LineDetailTimeSelection?> showLineDetailTimeFilterSheet(
  BuildContext context, {
  required String currentRangeLabel,
  required bool isAutomaticSelected,
  required int? selectedManualHour,
  required List<int> manualHours,
  LineCardPalette colors = LineCardColors.defaultPalette,
}) {
  return showModalBottomSheet<LineDetailTimeSelection>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) {
      return LineDetailTimeFilterSheet(
        colors: colors,
        currentRangeLabel: currentRangeLabel,
        isAutomaticSelected: isAutomaticSelected,
        selectedManualHour: selectedManualHour,
        manualHours: manualHours,
      );
    },
  );
}

class LineDetailTimeFilterSheet extends StatefulWidget {
  const LineDetailTimeFilterSheet({
    super.key,
    required this.currentRangeLabel,
    required this.isAutomaticSelected,
    required this.selectedManualHour,
    required this.manualHours,
    this.colors = LineCardColors.defaultPalette,
  });

  final String currentRangeLabel;
  final bool isAutomaticSelected;
  final int? selectedManualHour;
  final List<int> manualHours;
  final LineCardPalette colors;

  @override
  State<LineDetailTimeFilterSheet> createState() =>
      _LineDetailTimeFilterSheetState();
}

class _LineDetailTimeFilterSheetState extends State<LineDetailTimeFilterSheet> {
  late bool _isAutomaticSelected;
  late int? _selectedManualHour;

  @override
  void initState() {
    super.initState();

    _isAutomaticSelected = widget.isAutomaticSelected;
    _selectedManualHour = widget.selectedManualHour;
  }

  void _selectAutomatic() {
    setState(() {
      _isAutomaticSelected = true;
      _selectedManualHour = null;
    });
  }

  void _selectManualHour(int hour) {
    setState(() {
      _isAutomaticSelected = false;
      _selectedManualHour = hour;
    });
  }

  void _confirm() {
    if (_isAutomaticSelected) {
      Navigator.of(context).pop(const LineDetailTimeSelection.automatic());
      return;
    }

    final selectedHour = _selectedManualHour;

    if (selectedHour == null) {
      return;
    }

    Navigator.of(context).pop(LineDetailTimeSelection.manual(selectedHour));
  }

  @override
  Widget build(BuildContext context) {
    final colors = widget.colors;

    return SafeArea(
      top: false,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.76,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
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
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: colors.primaryText,
                          fontSize: 21,
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Scegli Automatico per usare l'ora locale del dispositivo "
                    'oppure seleziona una fascia manualmente.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
                    isSelected: _isAutomaticSelected,
                    onTap: _selectAutomatic,
                  ),
                  const SizedBox(height: 22),
                  Text(
                    'Selezione manuale',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: colors.mutedText,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                  ),
                  const SizedBox(height: 10),
                  ...widget.manualHours.map(
                    (hour) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _ManualTimeOption(
                          colors: colors,
                          label: _rangeLabelFromHour(hour),
                          isSelected: !_isAutomaticSelected &&
                              _selectedManualHour == hour,
                          onTap: () => _selectManualHour(hour),
                        ),
                      );
                    },
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

  String _rangeLabelFromHour(int hour) {
    final endHour = hour + 1;

    return '${hour.toString().padLeft(2, '0')}:00 - '
        '${endHour.toString().padLeft(2, '0')}:00';
  }
}

class _AutomaticTimeOption extends StatelessWidget {
  const _AutomaticTimeOption({
    required this.colors,
    required this.currentRangeLabel,
    required this.isSelected,
    required this.onTap,
  });

  final LineCardPalette colors;
  final String currentRangeLabel;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const accentColor = Color(0xFF2F7DF6);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
          decoration: BoxDecoration(
            color: isSelected
                ? accentColor.withValues(alpha: 0.08)
                : LineDetailColors.softSurface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color:
                  isSelected ? accentColor.withValues(alpha: 0.3) : colors.border,
              width: isSelected ? 1.4 : 1,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Automatico',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: colors.primaryText,
                            fontSize: 13.5,
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Usa l'ora locale del dispositivo. "
                      'Fascia attuale: $currentRangeLabel',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: colors.secondaryText,
                            fontSize: 12,
                            height: 1.4,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              _SelectionIndicator(
                isSelected: isSelected,
                selectedColor: accentColor,
                colors: colors,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ManualTimeOption extends StatelessWidget {
  const _ManualTimeOption({
    required this.colors,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final LineCardPalette colors;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const accentColor = Color(0xFF2F7DF6);

    final borderColor =
        isSelected ? accentColor.withValues(alpha: 0.3) : colors.border;

    final backgroundColor = isSelected
        ? accentColor.withValues(alpha: 0.08)
        : LineDetailColors.softSurface;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: borderColor,
              width: isSelected ? 1.4 : 1,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: isSelected
                      ? accentColor.withValues(alpha: 0.12)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.access_time_rounded,
                  color: isSelected ? accentColor : colors.secondaryText,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: colors.primaryText,
                        fontSize: 13.5,
                        fontWeight:
                            isSelected ? FontWeight.w800 : FontWeight.w700,
                      ),
                ),
              ),
              const SizedBox(width: 10),
              _SelectionIndicator(
                isSelected: isSelected,
                selectedColor: accentColor,
                colors: colors,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SelectionIndicator extends StatelessWidget {
  const _SelectionIndicator({
    required this.isSelected,
    required this.selectedColor,
    required this.colors,
  });

  final bool isSelected;
  final Color selectedColor;
  final LineCardPalette colors;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? selectedColor : Colors.transparent,
        border: Border.all(
          color: isSelected
              ? selectedColor
              : colors.mutedText.withValues(alpha: 0.45),
          width: isSelected ? 0 : 1.6,
        ),
      ),
      alignment: Alignment.center,
      child: isSelected
          ? const Icon(
              Icons.check_rounded,
              size: 16,
              color: Colors.white,
            )
          : null,
    );
  }
}

class _SheetActionBar extends StatelessWidget {
  const _SheetActionBar({
    required this.colors,
    required this.onCancel,
    required this.onConfirm,
  });

  final LineCardPalette colors;
  final VoidCallback onCancel;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(26, 14, 26, 18),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: colors.border)),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: onCancel,
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(56),
                foregroundColor: colors.secondaryText,
                side: BorderSide(color: colors.border),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                'Annulla',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: FilledButton(
              onPressed: onConfirm,
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(56),
                backgroundColor: const Color(0xFF2F7DF6),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                'Conferma',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
          ),
        ],
      ),
    );
  }
}