import 'package:flutter/material.dart';

import 'line_card_colors.dart';

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

  // Palette propria della label centrale.
  final LineCardPalette colors;

  @override
  Widget build(BuildContext context) {
    final isEnd = crossAxisAlignment == CrossAxisAlignment.end;

    return Column(
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

        const SizedBox(height: 3),

        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
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