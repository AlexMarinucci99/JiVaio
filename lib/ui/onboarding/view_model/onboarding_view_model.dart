import 'package:flutter/foundation.dart';

import '../../../data/repositories/onboarding_repository.dart';

/// Gestisce stato e azioni della schermata di onboarding.
///
/// Il ViewModel espone le slide da mostrare, tiene traccia della pagina
/// corrente e salva la preferenza scelta dall'utente.
class OnboardingViewModel extends ChangeNotifier {
  OnboardingViewModel({required OnboardingRepository onboardingRepository})
    : _repository = onboardingRepository;

  final OnboardingRepository _repository;

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
  bool _hideOnboardingNextTime = false;

  int get currentPage => _currentPage;

  bool get isLastPage => _currentPage == items.length - 1;

  bool get hideOnboardingNextTime => _hideOnboardingNextTime;

  void updatePage(int index) {
    if (_currentPage == index) return;

    _currentPage = index;
    notifyListeners();
  }

  /// Alterna la preferenza per le aperture successive.
  void toggleHideOnboardingNextTime() {
    _hideOnboardingNextTime = !_hideOnboardingNextTime;
    notifyListeners();
  }

  Future<void> completeOnboarding() =>
      _repository.setSkipOnboarding(_hideOnboardingNextTime);
}

///Contenuto di una slide della schermata onboarding.
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
