import 'package:flutter/material.dart';

/// Mostra un avviso nella schermata Home.
Future<void> showHomeAlertDialog(
  BuildContext context, {
  required String title,
  required String message,
  required String dismissLabel,
  required String confirmLabel,
  required VoidCallback onConfirm,
}) => showDialog<void>(
  context: context,
  builder: (dialogContext) => AlertDialog(
    title: Text(title),
    content: Text(message),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(dialogContext),
        child: Text(dismissLabel),
      ),
      TextButton(
        onPressed: () {
          Navigator.pop(dialogContext);
          onConfirm();
        },
        child: Text(confirmLabel),
      ),
    ],
  ),
);