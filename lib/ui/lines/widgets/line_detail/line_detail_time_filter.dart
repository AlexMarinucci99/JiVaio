import 'package:flutter/material.dart';

import '../line_card/line_card_colors.dart';

Future<void> showLineDetailTimeFilterSheet(
  BuildContext context, {
  LineCardPalette colors = LineCardColors.defaultPalette,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) {
      return LineDetailTimeFilterSheet(colors: colors);
    },
  );
}

class LineDetailTimeFilterSheet extends StatelessWidget {
  const LineDetailTimeFilterSheet({
    super.key,
    this.colors = LineCardColors.defaultPalette,
  });

  final LineCardPalette colors;

  static const String _currentRangeLabel = '17:00 - 18:00';
  static const String _selectedManualRange = '08:00 - 09:00';

  static const List<String> _manualRanges = [
    '08:00 - 09:00',
    '09:00 - 10:00',
    '10:00 - 11:00',
    '11:00 - 12:00',
    '12:00 - 13:00',
    '13:00 - 14:00',
    '14:00 - 15:00',
    '15:00 - 16:00',
    '16:00 - 17:00',
    '17:00 - 18:00',
  ];

  @override
  Widget build(BuildContext context) {
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
                    currentRangeLabel: _currentRangeLabel,
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

                  ..._manualRanges.map(
                    (range) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _ManualTimeOption(
                          colors: colors,
                          label: range,
                          isSelected: range == _selectedManualRange,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            _SheetActionBar(colors: colors),
          ],
        ),
      ),
    );
  }
}

class _AutomaticTimeOption extends StatelessWidget {
  const _AutomaticTimeOption({
    required this.colors,
    required this.currentRangeLabel,
  });

  final LineCardPalette colors;
  final String currentRangeLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F6FB),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colors.border),
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

          AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.transparent,
              border: Border.all(
                color: colors.mutedText.withValues(alpha: 0.45),
                width: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ManualTimeOption extends StatelessWidget {
  const _ManualTimeOption({
    required this.colors,
    required this.label,
    required this.isSelected,
  });

  final LineCardPalette colors;
  final String label;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    const accentColor = Color(0xFF2F7DF6);

    final borderColor = isSelected
        ? accentColor.withValues(alpha: 0.3)
        : colors.border;

    final backgroundColor = isSelected
        ? accentColor.withValues(alpha: 0.08)
        : const Color(0xFFF3F6FB);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {},
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
            crossAxisAlignment: CrossAxisAlignment.start,
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

              AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? accentColor : Colors.transparent,
                  border: Border.all(
                    color: isSelected
                        ? accentColor
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SheetActionBar extends StatelessWidget {
  const _SheetActionBar({
    required this.colors,
  });

  final LineCardPalette colors;

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
              onPressed: () => Navigator.of(context).pop(),
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
              onPressed: () => Navigator.of(context).pop(),
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