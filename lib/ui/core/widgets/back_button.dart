import 'package:flutter/material.dart';

import '../themes/app_colors.dart';

/// Mostra il pulsante standard per tornare alla schermata precedente.
class AppBackButton extends StatelessWidget {
  const AppBackButton({
    super.key,
    required this.onPressed,
    this.tooltip = 'Torna indietro',
  });

  final VoidCallback onPressed;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.backButtonBackground,
      shape: const CircleBorder(),
      child: IconButton(
        tooltip: tooltip,
        icon: const Icon(Icons.arrow_back_rounded, size: 20),
        color: AppColors.primary,
        onPressed: onPressed,
      ),
    );
  }
}
