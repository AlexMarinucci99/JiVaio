import 'package:flutter/material.dart';

import '../theme/settings_colors.dart';

/// Singola voce visualizzata all'interno
/// di una sezione delle impostazioni.
///
/// Il widget gestisce soltanto la presentazione.
/// L'eventuale azione viene ricevuta tramite [onTap].
class SettingsTile extends StatelessWidget {
  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.showChevron = false,
    this.isDestructive = false,
  });

  final IconData icon;

  final String title;

  final String subtitle;

  /// Azione comunicata dal widget padre.
  ///
  /// Se è null, la riga rimane soltanto informativa.
  final VoidCallback? onTap;

  /// Indica se mostrare la freccia laterale.
  final bool showChevron;

  /// Indica se la voce rappresenta un'azione distruttiva.
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final actionColor = isDestructive
        ? SettingsColors.dangerAction
        : SettingsColors.primaryAction;

    return Semantics(
      button: onTap != null,
      label: title,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: actionColor.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(icon, size: 20, color: actionColor),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: textTheme.bodyLarge?.copyWith(
                        color: isDestructive
                            ? SettingsColors.dangerAction
                            : SettingsColors.titleText,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: textTheme.bodySmall?.copyWith(
                        color: SettingsColors.secondaryText,
                        fontSize: 11.5,
                        height: 1.3,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              if (showChevron)
                const Icon(
                  Icons.chevron_right_rounded,
                  size: 22,
                  color: SettingsColors.secondaryText,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
