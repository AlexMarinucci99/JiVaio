import 'package:flutter/material.dart';

import '../../theme/line_card_colors.dart';

/// Controllo condiviso per invertire la direzione di una linea.
///
/// Mostra una freccia per le linee unidirezionali e disabilita lo swap
/// quando il cambio di direzione non è disponibile.
class LineDirectionButton extends StatelessWidget {
  const LineDirectionButton({
    super.key,
    required this.isUnidirectional,
    required this.canSwapDirection,
    required this.onSwapDirection,
    this.iconSize = 18,
    this.colors = LineCardColors.defaultPalette,
  });

  final bool isUnidirectional;
  final bool canSwapDirection;

  /// Callback eseguita quando l’utente inverte la direzione.
  final VoidCallback onSwapDirection;

  /// Dimensione dell’icona, personalizzabile nei diversi contesti.
  final double iconSize;

  final LineCardPalette colors;

  @override
  Widget build(BuildContext context) {
    final isSwapEnabled = canSwapDirection && !isUnidirectional;

    final foregroundColor = canSwapDirection || isUnidirectional
        ? colors.directionButtonForeground
        : colors.directionButtonDisabledForeground;

    return Material(
      color: colors.directionButtonBackground,
      shape: const CircleBorder(),
      child: IconButton(
        visualDensity: VisualDensity.compact,
        onPressed: isSwapEnabled ? onSwapDirection : null,
        icon: Icon(
          isUnidirectional
              ? Icons.arrow_forward_rounded
              : Icons.swap_horiz_rounded,
          color: foregroundColor,
          size: iconSize,
        ),
        tooltip: isSwapEnabled ? 'Inverti direzione' : 'Direzione unica',
      ),
    );
  }
}
