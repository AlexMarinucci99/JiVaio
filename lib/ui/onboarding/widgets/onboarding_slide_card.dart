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

    // Colore usato per l'icona circolare.
    final effectiveAccentColor = accentColor ?? colorScheme.primary;

    return Padding(
      // Margine laterale dell'intera slide.
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Spazio superiore.
          const SizedBox(height: 8),

          // Box immagine con proporzioni fisse.
          AspectRatio(
            aspectRatio: 1.55,
            child: Container(
              width: double.infinity,

              // Sfondo bianco e angoli arrotondati della box.
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
              ),

              // Mantiene l'immagine dentro gli angoli arrotondati.
              clipBehavior: Clip.antiAlias,

              // Stack: immagine sotto, icona sopra a destra.
              child: Stack(
                children: [
                  // Immagine principale della slide.
                  Positioned.fill(
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.cover,
                      alignment: imageAlignment,
                      filterQuality: FilterQuality.high,
                    ),
                  ),

                  // Icona superiore destra, mostrata solo se presente.
                  if (icon != null)
                    Positioned(
                      top: 18,
                      right: 18,
                      child: Container(
                        width: 58,
                        height: 58,
                        decoration: BoxDecoration(
                          // Cerchio bianco opaco dietro l'icona.
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.88),
                        ),
                        child: Icon(
                          icon,

                          // Icona centrale colorata.
                          color: effectiveAccentColor,
                          size: 28,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Spazio tra box immagine e titolo.
          const SizedBox(height: 34),

          // Titolo della slide.
          Text(
            title,
            textAlign: TextAlign.left,
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
              height: 1.12,
              color: const Color(0xFF101828),
            ),
          ),

          // Spazio tra titolo e descrizione.
          const SizedBox(height: 10),

          // Descrizione della slide.
          Text(
            description,
            textAlign: TextAlign.left,
            style: textTheme.bodyLarge?.copyWith(
              height: 1.65,
              color: const Color(0xFF667085),
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
