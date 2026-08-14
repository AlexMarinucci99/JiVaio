import 'package:flutter/material.dart';

import '../theme/settings_colors.dart';

/// Raggruppa un insieme di voci appartenenti
/// alla stessa categoria delle impostazioni.
class SettingsSection extends StatelessWidget {
  const SettingsSection({
    super.key,
    required this.title,
    required this.children,
    this.colors = const SettingsColors(),
  });

  /// Titolo della sezione, ad esempio Account o Notifiche.
  final String title;

  /// Voci visualizzate all'interno della card.
  final List<Widget> children;

  /// Colori della schermata delle impostazioni.
  final SettingsColors colors;

  @override
  Widget build(BuildContext context) {
    assert(
      children.isNotEmpty,
      'Una sezione delle impostazioni deve contenere almeno una voce.',
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 2, bottom: 8),
          child: Text(
            title.toUpperCase(),
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: colors.sectionLabel,
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
            ),
          ),
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: colors.cardBackground,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: colors.cardBorder),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(19),
            child: Material(
              color: colors.cardBackground,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: _buildChildrenWithDividers(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildChildrenWithDividers() => [
    for (var index = 0; index < children.length; index++) ...[
      if (index > 0)
        Divider(height: 1, thickness: 1, indent: 68, color: colors.cardBorder),
      children[index],
    ],
  ];
}
