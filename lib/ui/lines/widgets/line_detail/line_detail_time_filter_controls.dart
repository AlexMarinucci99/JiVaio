part of 'line_detail_time_filter.dart';

const _timeOptionBorderRadius = BorderRadius.all(Radius.circular(18));
const _timeFilterAccentColor = LineDetailColors.timeFilterAccent;

Color _timeOptionBackground(bool isSelected) => isSelected
    ? _timeFilterAccentColor.withValues(alpha: 0.08)
    : LineDetailColors.softSurface;

Color _timeOptionBorder(bool isSelected, LineCardPalette colors) =>
    isSelected ? _timeFilterAccentColor.withValues(alpha: 0.3) : colors.border;

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
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: LineDetailColors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: _timeOptionBorderRadius,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: _timeOptionBackground(isSelected),
            borderRadius: _timeOptionBorderRadius,
            border: Border.all(
              color: _timeOptionBorder(isSelected, colors),
              width: isSelected ? 1.4 : 1,
            ),
          ),
          child: Row(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Automatico',
                      style: textTheme.titleMedium?.copyWith(
                        color: colors.primaryText,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Usa l'ora locale del dispositivo. "
                      'Fascia attuale: $currentRangeLabel',
                      style: textTheme.bodySmall?.copyWith(
                        color: colors.secondaryText,
                        fontSize: 12,
                        height: 1.4,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              _SelectionIndicator(isSelected: isSelected, colors: colors),
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
    return Material(
      color: LineDetailColors.transparent,
      child: InkWell(
        borderRadius: _timeOptionBorderRadius,
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: _timeOptionBackground(isSelected),
            borderRadius: _timeOptionBorderRadius,
            border: Border.all(
              color: _timeOptionBorder(isSelected, colors),
              width: isSelected ? 1.4 : 1,
            ),
          ),
          child: Row(
            spacing: 10,
            children: [
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: colors.primaryText,
                    fontSize: 13.5,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w700,
                  ),
                ),
              ),
              _SelectionIndicator(isSelected: isSelected, colors: colors),
            ],
          ),
        ),
      ),
    );
  }
}

class _SelectionIndicator extends StatelessWidget {
  const _SelectionIndicator({required this.isSelected, required this.colors});

  final bool isSelected;
  final LineCardPalette colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected
            ? _timeFilterAccentColor
            : LineDetailColors.transparent,
        border: Border.all(
          color: isSelected
              ? _timeFilterAccentColor
              : colors.mutedText.withValues(alpha: 0.45),
          width: isSelected ? 0 : 1.6,
        ),
      ),
      alignment: Alignment.center,
      child: isSelected
          ? const Icon(
              Icons.check_rounded,
              size: 16,
              color: LineDetailColors.onAccent,
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
    const buttonShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
    );

    return Container(
      padding: const EdgeInsets.fromLTRB(26, 14, 26, 18),
      decoration: BoxDecoration(
        color: LineDetailColors.surface,
        border: Border(top: BorderSide(color: colors.border)),
      ),
      child: Row(
        spacing: 16,
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: onCancel,
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(56),
                foregroundColor: colors.secondaryText,
                side: BorderSide(color: colors.border),
                shape: buttonShape,
              ),
              child: const Text(
                'Annulla',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
          ),
          Expanded(
            child: FilledButton(
              onPressed: onConfirm,
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(56),
                backgroundColor: _timeFilterAccentColor,
                foregroundColor: LineDetailColors.onAccent,
                shape: buttonShape,
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
