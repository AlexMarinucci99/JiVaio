import 'package:flutter/material.dart';

import 'line_card_colors.dart';

class LineSaveButton extends StatelessWidget {
  const LineSaveButton({
    super.key,
    required this.isSaved,
    required this.onPressed,
  });

  final bool isSaved;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        isSaved ? Icons.favorite_rounded : Icons.favorite_border_rounded,
        color: isSaved ? LineCardColors.savedHeart : LineCardColors.mutedText,
      ),
      tooltip: isSaved ? 'Rimuovi dai salvati' : 'Salva linea',
    );
  }
}
