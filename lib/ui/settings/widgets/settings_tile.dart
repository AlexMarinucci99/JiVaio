import 'package:flutter/material.dart';

import '../theme/settings_screen_colors.dart';

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
    required this.iconColor,
    this.onTap,
    this.trailing,
    this.showChevron = true,
    this.isDestructive = false,
    this.enabled = true,
    this.colors = const SettingsScreenColors(),
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color iconColor;

  /// Azione comunicata dal widget padre.
  ///
  /// Se è null, la riga rimane soltanto informativa.
  final VoidCallback? onTap;

  /// Widget facoltativo mostrato a destra.
  ///
  /// Può essere usato, ad esempio, per visualizzare la versione.
  final Widget? trailing;

  final bool showChevron;
  final bool isDestructive;
  final bool enabled;

  final SettingsScreenColors colors;

  @override
  Widget build(BuildContext context) {
    final effectiveIconColor = _effectiveIconColor;
    final effectiveTitleColor = _effectiveTitleColor;

    return Semantics(
      button: onTap != null,
      enabled: enabled,
      label: title,
      child: InkWell(
        onTap: enabled ? onTap : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: effectiveIconColor.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: effectiveIconColor,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: effectiveTitleColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: enabled
                            ? colors.secondaryText
                            : colors.secondaryText.withValues(alpha: 0.55),
                        fontSize: 11.5,
                        height: 1.3,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              if (trailing != null)
                trailing!
              else if (showChevron)
                Icon(
                  Icons.chevron_right_rounded,
                  size: 22,
                  color: enabled
                      ? colors.secondaryText
                      : colors.secondaryText.withValues(alpha: 0.45),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Color get _effectiveIconColor {
    if (!enabled) {
      return colors.secondaryText.withValues(alpha: 0.55);
    }

    if (isDestructive) {
      return colors.dangerAction;
    }

    return iconColor;
  }

  Color get _effectiveTitleColor {
    if (!enabled) {
      return colors.secondaryText.withValues(alpha: 0.55);
    }

    if (isDestructive) {
      return colors.dangerAction;
    }

    return colors.titleText;
  }
}