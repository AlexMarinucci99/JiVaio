import 'package:flutter/material.dart';

/// Palette della card usata per mostrare una slide dell'onboarding.
class OnboardingSlideCardColors {
  const OnboardingSlideCardColors({
    this.imageCardBackgroundColor = Colors.white,
    this.iconBackgroundColor = const Color(0xE0FFFFFF),
    this.accentColor = const Color.fromARGB(255, 224, 224, 230),
    this.titleColor = const Color.fromARGB(255, 210, 214, 223),
    this.descriptionColor = const Color.fromARGB(255, 219, 222, 228),
  });

  /// Colore dello sfondo della card immagine.
  final Color imageCardBackgroundColor;

  /// Colore del cerchio dietro l'icona.
  final Color iconBackgroundColor;

  /// Colore principale usato per l'icona.
  final Color accentColor;

  /// Colore del titolo.
  final Color titleColor;

  /// Colore della descrizione.
  final Color descriptionColor;
}

/// Card che mostra il contenuto di una singola slide dell'onboarding.
///
/// Riceve dati e configurazione grafica dall'esterno, senza gestire
/// stato, navigazione o avanzamento delle pagine.
class OnboardingSlideCard extends StatelessWidget {
  const OnboardingSlideCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.description,
    this.icon,
    this.accentColor,
    this.imageAlignment = Alignment.center,
    this.colors = const OnboardingSlideCardColors(),
  });

  final String imagePath;

  final String title;

  final String description;

  final IconData? icon;

  /// Colore opzionale che sovrascrive [OnboardingSlideCardColors.accentColor].
  ///
  /// Rimane disponibile per permettere alla schermata di assegnare
  /// un colore diverso a ogni slide.
  final Color? accentColor;

  /// Allineamento dell'immagine dentro la card.
  final Alignment imageAlignment;

  // Palette colori propria della slide.
  final OnboardingSlideCardColors colors;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final effectiveAccentColor = accentColor ?? colors.accentColor;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          AspectRatio(
            aspectRatio: 1.55,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: colors.imageCardBackgroundColor,
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
                      filterQuality: FilterQuality.high,
                    ),
                  ),

                  if (icon != null)
                    Positioned(
                      top: 18,
                      right: 18,
                      child: Container(
                        width: 58,
                        height: 58,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colors.iconBackgroundColor,
                        ),
                        child: Icon(
                          icon,
                          color: effectiveAccentColor,
                          size: 28,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 34),

          Text(
            title,
            textAlign: TextAlign.left,
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
              height: 1.12,
              color: colors.titleColor,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            description,
            textAlign: TextAlign.left,
            style: textTheme.bodyLarge?.copyWith(
              height: 1.65,
              color: colors.descriptionColor,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
