import 'package:flutter/foundation.dart';

class OnboardingViewModel extends ChangeNotifier {
  final List<OnboardingItem> items = const [
    OnboardingItem(
      imagePath: 'assets/onboarding/onboarding_1.png',
      title: 'Trova la tua Fermata',
      description:
          'Individua la fermata più vicina usando il gps e pianifica il tuo percorso in pochi secondi.',
    ),
    OnboardingItem(
      imagePath: 'assets/onboarding/onboarding_2.png',
      title: 'Orari a portata di mano',
      description:
          'Consulta rapidamente linee, fermate e partenze. '
          '\nGli orari disponibili sono indicativi e possono subire variazioni.',
    ),
    OnboardingItem(
      imagePath: 'assets/onboarding/onboarding_3.png',
      title: 'Viaggia con più semplicità',
      description:
          'Salva le tue linee preferite e ricevi notifiche utili durante il viaggio.',
    ),
  ];

  int _currentPage = 0;

  int get currentPage => _currentPage;

  bool get isLastPage => _currentPage == items.length - 1;

  void updatePage(int index) {
    if (_currentPage == index) return;

    _currentPage = index;
    notifyListeners();
  }
}

class OnboardingItem {
  const OnboardingItem({
    required this.imagePath,
    required this.title,
    required this.description,
  });

  final String imagePath;
  final String title;
  final String description;
}
