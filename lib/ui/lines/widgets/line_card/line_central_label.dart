import 'package:flutter/material.dart';

import '../../theme/line_card_colors.dart';

/// Label testuale usata nella sezione centrale della card linea.
///
/// Mostra una didascalia e un valore, rispettando l'allineamento
/// configurato dal widget padre.
class LineCentralLabel extends StatelessWidget {
  const LineCentralLabel({
    super.key,
    required this.caption,
    required this.value,
    required this.crossAxisAlignment,
    this.colors = LineCardColors.defaultPalette,
  });

  final String caption;
  final String value;
  final CrossAxisAlignment crossAxisAlignment;
  final LineCardPalette colors;

  @override
  Widget build(BuildContext context) {
    final isEnd = crossAxisAlignment == CrossAxisAlignment.end;

    return Column(
      spacing: 3,
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Text(
          caption,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: colors.labelAccent,
            fontSize: 9.5,
            letterSpacing: 0.8,
            fontWeight: FontWeight.w800,
          ),
        ),
        Text(
          value,
          textAlign: isEnd ? TextAlign.end : TextAlign.start,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: colors.primaryText,
            fontSize: 12.5,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
