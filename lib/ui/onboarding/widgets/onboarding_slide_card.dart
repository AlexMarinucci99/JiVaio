import 'package:flutter/material.dart';

import '../theme/onboarding_colors.dart';

/// Card che mostra il contenuto di una singola slide dell'onboarding.

class OnboardingSlideCard extends StatelessWidget {
  const OnboardingSlideCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.description,
    required this.icon,
    required this.accentColor,
    this.imageAlignment = Alignment.center,
  });

  final String imagePath;
  final String title;
  final String description;
  final IconData icon;

  /// Colore specifico dell'icona della slide.
  final Color accentColor;
  final Alignment imageAlignment;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          AspectRatio(
            aspectRatio: 1.55,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.cover,
                      alignment: imageAlignment,
                    ),
                  ),

                  Positioned(
                    top: 18,
                    right: 18,
                    child: Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: OnboardingColors.surface,
                      ),
                      child: Icon(icon, color: accentColor, size: 28),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 34),

          Text(
            title,
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
              height: 1.12,
              color: OnboardingColors.title,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            description,
            style: textTheme.bodyLarge?.copyWith(
              height: 1.65,
              color: OnboardingColors.description,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
