import 'package:flutter/material.dart';

import '../theme/settings_colors.dart';

/// Raggruppa un insieme di voci appartenenti
/// alla stessa categoria delle impostazioni.
class SettingsSection extends StatelessWidget {
  const SettingsSection({
    super.key,
    required this.title,
    required this.children,
  });

  final String title;

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 2, bottom: 8),
          child: Text(
            title.toUpperCase(),
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: SettingsColors.sectionLabel,
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
            ),
          ),
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: SettingsColors.cardBackground,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: SettingsColors.cardBorder),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(19),
            child: Material(
              color: SettingsColors.cardBackground,
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
       const Divider(
  height: 1,
  thickness: 1,
  indent: 68,
  color: SettingsColors.cardBorder,
),
      children[index],
    ],
  ];
}
