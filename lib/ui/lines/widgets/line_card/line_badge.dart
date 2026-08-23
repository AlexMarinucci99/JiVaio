import 'package:flutter/material.dart';

import '../../theme/line_card_colors.dart';

/// Badge visivo che identifica una linea urbana.

class LineBadge extends StatelessWidget {
  const LineBadge({super.key, required this.shortName, required this.colors});

  final String shortName;
  final LineCardPalette colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: colors.listAccent,
        borderRadius: BorderRadius.circular(16),
      ),
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            shortName,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: LineCardColors.textOn(colors.listAccent, colors: colors),
              fontWeight: FontWeight.w900,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
