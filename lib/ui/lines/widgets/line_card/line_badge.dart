import 'package:flutter/material.dart';

/// Badge visivo che identifica una linea urbana.
///
/// Mostra il nome breve della linea usando colori ricevuti dall'esterno,
/// così può essere riutilizzato in card, dettagli e liste.
class LineBadge extends StatelessWidget {
  const LineBadge({
    super.key,
    required this.shortName,
    required this.backgroundColor,
    required this.textColor,
  });

  final String shortName;
  final Color backgroundColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: backgroundColor,
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
              color: textColor,
              fontWeight: FontWeight.w900,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
