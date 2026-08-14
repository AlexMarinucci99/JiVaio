import 'package:flutter/material.dart';

import '../theme/home_colors.dart';

/// Mostra un avviso con lo stile minimale della Home.
Future<void> showHomeAlertDialog(
  BuildContext context, {
  required String title,
  required String message,
  required String dismissLabel,
  required String confirmLabel,
  required VoidCallback onConfirm,
  HomeAlertDialogColors colors = const HomeAlertDialogColors(),
}) => showDialog<void>(
  context: context,
  barrierColor: colors.barrierColor,
  builder: (dialogContext) => AlertDialog(
    insetPadding: const EdgeInsets.symmetric(horizontal: 30),
    contentPadding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
    backgroundColor: colors.backgroundColor,
    surfaceTintColor: colors.backgroundColor,
    elevation: 0,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(18)),
    ),
    title: Text(title, style: TextStyle(color: colors.primaryTextColor)),
    content: Text(message, style: TextStyle(color: colors.secondaryTextColor)),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(dialogContext),
        style: TextButton.styleFrom(foregroundColor: colors.secondaryTextColor),
        child: Text(dismissLabel),
      ),
      TextButton(
        onPressed: () {
          Navigator.pop(dialogContext);
          onConfirm();
        },
        style: TextButton.styleFrom(foregroundColor: colors.accentColor),
        child: Text(confirmLabel),
      ),
    ],
  ),
);
