import 'package:flutter/material.dart';

import 'line_card_colors.dart';

class LineSaveButton extends StatelessWidget {
  const LineSaveButton({
    super.key,
    required this.isSaved,
    required this.onPressed,
    this.colors = LineCardColors.defaultPalette,
  });

  final bool isSaved;
  final VoidCallback onPressed;

  // Palette propria del bottone salva.
  final LineCardPalette colors;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        isSaved ? Icons.favorite_rounded : Icons.favorite_border_rounded,
        color: isSaved ? colors.savedHeart : colors.mutedText,
      ),
      tooltip: isSaved ? 'Rimuovi dai salvati' : 'Salva linea',
    );
  }
}
