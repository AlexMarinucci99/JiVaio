import 'package:flutter/material.dart';

import '../../core/themes/app_colors.dart';

/// Palette della schermata Impostazioni.
///
/// Mantiene separati i colori specifici della feature
/// dalla struttura dei widget.
class SettingsScreenColors {
  const SettingsScreenColors({
    this.pageBackground = const Color(0xFFF6FAFF),
    this.gradientStart = const Color(0xFFF6FAFF),
    this.gradientEnd = const Color(0xFFF2F6FC),
    this.titleText = AppColors.textPrimary,
    this.secondaryText = AppColors.textSecondary,
    this.sectionLabel = const Color(0xFF7A8494),
    this.cardBackground = AppColors.surface,
    this.cardBorder = const Color(0xFFE5EAF2),
    this.cardShadow = const Color(0xFF0F172A),
    this.primaryAction = AppColors.primary,
    this.dangerAction = AppColors.error,
    this.iconBackground = const Color(0xFFEAF0FA),
    this.profileGradientStart = AppColors.primary,
    this.profileGradientEnd = const Color(0xFF3347A0),
    this.profileForeground = Colors.white,
    this.profileSecondaryText = const Color(0xFFDCE5FF),
  });

  final Color pageBackground;

  final Color gradientStart;
  final Color gradientEnd;

  final Color titleText;
  final Color secondaryText;
  final Color sectionLabel;

  final Color cardBackground;
  final Color cardBorder;
  final Color cardShadow;

  final Color primaryAction;
  final Color dangerAction;
  final Color iconBackground;

  final Color profileGradientStart;
  final Color profileGradientEnd;
  final Color profileForeground;
  final Color profileSecondaryText;
}