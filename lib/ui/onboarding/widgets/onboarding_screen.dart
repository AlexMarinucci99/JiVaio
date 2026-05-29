import 'package:flutter/material.dart';

import '../../../data/services/onboarding_preferences_service.dart';
import '../../../routing/app_routes.dart';
import '../theme/onboarding_colors.dart';
import '../view_model/onboarding_view_model.dart';
import 'hide_onboarding_preference.dart';
import 'onboarding_bottom_controls.dart';
import 'onboarding_slide_card.dart';

// StatefulWidget: schermata principale che contiene le 3 pagine di onboarding.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final OnboardingPreferencesService _onboardingPreferencesService =
      OnboardingPreferencesService();

  final PageController _pageController = PageController();
  final OnboardingViewModel _viewModel = OnboardingViewModel();

  // Stato della checkbox "Non mostrarla più".
  bool _hideOnboardingNextTime = false;

  // Palette colori della feature onboarding.
  static const OnboardingColors _colors = OnboardingColors();

  static const List<_OnboardingVisualData> _visuals = [
    _OnboardingVisualData(
      icon: Icons.place_rounded,
      accentColor: Color(0xFF00A7A7),
    ),
    _OnboardingVisualData(
      icon: Icons.access_time_rounded,
      accentColor: Color(0xFF2563EB),
    ),
    _OnboardingVisualData(
      icon: Icons.favorite_rounded,
      accentColor: Color(0xFFE53935),
      imageAlignment: Alignment.topCenter,
    ),
  ];

  // Bottone "Avanti" / "Inizia".
  Future<void> _goNext() async {
    if (_viewModel.isLastPage) {
      await _onboardingPreferencesService.setSkipOnboarding(
        _hideOnboardingNextTime,
      );

      if (!mounted) return;

      Navigator.pushReplacementNamed(context, AppRoutes.authChoice);
      return;
    }

    await _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }

  // Bottone "Indietro".
  void _goBack() {
    if (_viewModel.currentPage == 0) return;

    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }

  // Bottone "Salta" superiore.
  Future<void> _skip() async {
    if (_viewModel.isLastPage) {
      await _onboardingPreferencesService.setSkipOnboarding(
        _hideOnboardingNextTime,
      );
    }

    if (!mounted) return;

    Navigator.pushReplacementNamed(context, AppRoutes.authChoice);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _viewModel,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: _colors.backgroundColor,
          body: SafeArea(
            child: Column(
              children: [
                // Bottone "Salta" superiore destro.
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: _skip,
                      style: TextButton.styleFrom(
                        foregroundColor: _colors.skipButtonColor,
                      ),
                      child: const Text('Salta'),
                    ),
                  ),
                ),

                // PageView con le 3 slide onboarding.
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _viewModel.items.length,
                    onPageChanged: _viewModel.updatePage,
                    itemBuilder: (context, index) {
                      final item = _viewModel.items[index];
                      final visual = _visuals[index];

                      return OnboardingSlideCard(
                        imagePath: item.imagePath,
                        title: item.title,
                        description: item.description,
                        icon: visual.icon,
                        accentColor: visual.accentColor,
                        imageAlignment: visual.imageAlignment,
                        colors: _colors.slideCardColors,
                      );
                    },
                  ),
                ),

                // Area inferiore: box opzionale + controlli finali.
                Padding(
                  padding: const EdgeInsets.fromLTRB(28, 12, 28, 32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Box "Non mostrarla più".
                      // Compare solo nella terza schermata di onboarding.
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 180),
                        switchInCurve: Curves.easeOutCubic,
                        switchOutCurve: Curves.easeOutCubic,
                        child: _viewModel.isLastPage
                            ? HideOnboardingPreference(
                                key: const ValueKey(
                                  'hide_onboarding_preference',
                                ),
                                value: _hideOnboardingNextTime,
                                colors: _colors.hidePreferenceColors,
                                onChanged: () {
                                  setState(() {
                                    _hideOnboardingNextTime =
                                        !_hideOnboardingNextTime;
                                  });
                                },
                              )
                            : const SizedBox.shrink(
                                key: ValueKey('empty_onboarding_preference'),
                              ),
                      ),

                      // Spazio tra box e controlli inferiori.
                      if (_viewModel.isLastPage) const SizedBox(height: 16),

                      // Riga inferiore: indietro, dots, avanti/inizia.
                      OnboardingBottomControls(
                        currentIndex: _viewModel.currentPage,
                        itemCount: _viewModel.items.length,
                        isLastPage: _viewModel.isLastPage,
                        onBack: _goBack,
                        onNext: _goNext,
                        actionButtonColors: _colors.actionButtonColors,
                        dotsColors: _colors.dotsColors,
                        backButtonColor: _colors.backButtonColor,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _OnboardingVisualData {
  const _OnboardingVisualData({
    required this.icon,
    required this.accentColor,
    this.imageAlignment = Alignment.center,
  });

  final IconData icon;
  final Color accentColor;
  final Alignment imageAlignment;
}
