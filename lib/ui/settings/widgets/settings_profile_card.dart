import 'package:flutter/material.dart';

import '../theme/settings_colors.dart';

/// Card che mostra le informazioni principali dell'utente.
/// 
class SettingsProfileCard extends StatelessWidget {
 const SettingsProfileCard({
  super.key,
  required this.title,
  required this.subtitle,
  required this.isGuest,
});

  final String title;
  final String subtitle;
  final bool isGuest;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: SettingsColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: SettingsColors.cardBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: SettingsColors.iconBackground,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(
              isGuest ? Icons.person_outline_rounded : Icons.person_rounded,
              size: 31,
              color: SettingsColors.primaryAction,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: SettingsColors.titleText,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: SettingsColors.secondaryText,
                    fontSize: 13,
                    height: 1.3,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
