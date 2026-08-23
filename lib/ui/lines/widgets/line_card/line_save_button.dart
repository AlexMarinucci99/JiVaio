import 'package:flutter/material.dart';

import '../../theme/line_card_colors.dart';

/// Bottone per salvare o rimuovere una linea dai preferiti.

class LineSaveButton extends StatelessWidget {
  const LineSaveButton({
    super.key,
    required this.isSaved,
    required this.onPressed,
    this.colors = LineCardColors.defaultPalette,
  });

  final bool isSaved;
  final VoidCallback onPressed;
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
