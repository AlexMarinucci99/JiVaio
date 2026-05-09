import 'package:flutter/material.dart';

//StatelessWidget riceve e si limita a mostrare

class OnboardingSlideCard extends StatelessWidget {
  const OnboardingSlideCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.description,
    this.icon,
    this.accentColor,
    this.imageAlignment = Alignment.center,
  });

  final String imagePath;
  final String title;
  final String description;
  final IconData? icon;
  final Color? accentColor;
  final Alignment imageAlignment;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final effectiveAccentColor = accentColor ?? colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 12),

          Expanded(
            flex: 5,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    effectiveAccentColor.withValues(alpha: 0.14),
                    effectiveAccentColor.withValues(alpha: 0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: effectiveAccentColor.withValues(alpha: 0.12),
                    blurRadius: 24,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Image.asset(
                        imagePath,
                        fit: BoxFit.contain,
                        alignment: imageAlignment,
                      ),
                    ),
                  ),

                  if (icon != null)
                    Positioned(
                      top: 16,
                      right: 16,
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.88),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 14,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Icon(
                          icon,
                          color: effectiveAccentColor,
                          size: 24,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 32),

          Expanded(
            flex: 3,
            child: Column(
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    height: 1.15,
                    color: colorScheme.onSurface,
                  ),
                ),

                const SizedBox(height: 14),

                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: textTheme.bodyMedium?.copyWith(
                    height: 1.5,
                    color: colorScheme.onSurfaceVariant,
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
