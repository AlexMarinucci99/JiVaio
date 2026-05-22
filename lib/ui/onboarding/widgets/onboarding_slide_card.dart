import 'package:flutter/material.dart';

class OnboardingSlideCardColors {
  const OnboardingSlideCardColors({
    this.imageCardBackgroundColor = Colors.white,
    this.iconBackgroundColor = const Color(0xE0FFFFFF),
    this.accentColor = const Color.fromARGB(255, 224, 224, 230),
    this.titleColor = const Color.fromARGB(255, 210, 214, 223),
    this.descriptionColor = const Color.fromARGB(255, 219, 222, 228),
  });

  // Colore dello sfondo della card immagine.
  final Color imageCardBackgroundColor;

  // Colore del cerchio dietro l'icona.
  final Color iconBackgroundColor;

  // Colore principale usato per l'icona.
  final Color accentColor;

  // Colore del titolo.
  final Color titleColor;

  // Colore della descrizione.
  final Color descriptionColor;
}

// StatelessWidget: riceve i dati della singola slide e li mostra.
// Non gestisce stato, pagine o navigazione.
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

  // Mantenuto per compatibilità con il codice già scritto.
  // Se viene passato, sovrascrive colors.accentColor.
  final Color? accentColor;

  final Alignment imageAlignment;

  // Palette colori propria della slide.
  final OnboardingSlideCardColors colors;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    // Colore effettivo dell'icona.
    final effectiveAccentColor = accentColor ?? colors.accentColor;

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

              // Sfondo e angoli arrotondati della box immagine.
              decoration: BoxDecoration(
                color: colors.imageCardBackgroundColor,
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
                          // Cerchio dietro l'icona.
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

          // Spazio tra box immagine e titolo.
          const SizedBox(height: 34),

          // Titolo della slide.
          Text(
            title,
            textAlign: TextAlign.left,
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
              height: 1.12,
              color: colors.titleColor,
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
              color: colors.descriptionColor,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}