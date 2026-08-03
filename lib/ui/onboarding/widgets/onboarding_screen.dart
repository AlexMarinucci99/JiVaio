import 'package:flutter/material.dart';

import '../../../data/repositories/onboarding_repository.dart';
import '../../../routing/app_routes.dart';
import '../theme/onboarding_colors.dart';
import '../view_model/onboarding_view_model.dart';
import 'hide_onboarding_preference.dart';
import 'onboarding_bottom_controls.dart';
import 'onboarding_slide_card.dart';

/// Schermata principale dell'onboarding.
///
/// Mostra le slide introduttive, coordina la navigazione tra pagine
/// e delega al [OnboardingViewModel] la gestione dello stato e della preferenza.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key, required this.onboardingRepository});

  /// Repository usato per salvare la preferenza di visualizzazione.
  final OnboardingRepository onboardingRepository;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();

  late final OnboardingViewModel _viewModel;

  bool _isCompleting = false;

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

  @override
  void initState() {
    super.initState();

    _viewModel = OnboardingViewModel(
      onboardingRepository: widget.onboardingRepository,
    );
    assert(_visuals.length == _viewModel.items.length);
  }

  Future<void> _goNext() async {
    if (!_viewModel.isLastPage) {
      await _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
      );
      return;
    }

    if (_isCompleting) return;

    _isCompleting = true;

    try {
      await _viewModel.completeOnboarding();
    } catch (error) {
      debugPrint('Errore durante il salvataggio dell’onboarding: $error');

      if (mounted && _viewModel.hideOnboardingNextTime) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Non è stato possibile salvare la preferenza. '
              'L’onboarding potrebbe essere mostrato di nuovo.',
            ),
          ),
        );
      }
    }

    if (!mounted) return;

    _openAuth();
  }

  void _goBack() {
    if (_viewModel.currentPage == 0) return;

    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }

  void _openAuth() {
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
        final items = _viewModel.items;
        final isLastPage = _viewModel.isLastPage;

        return Scaffold(
          backgroundColor: _colors.backgroundColor,
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Visibility(
                      visible: !isLastPage,
                      maintainSize: true,
                      maintainAnimation: true,
                      maintainState: true,
                      child: TextButton(
                        onPressed: _openAuth,
                        style: TextButton.styleFrom(
                          foregroundColor: _colors.skipButtonColor,
                        ),
                        child: const Text('Salta'),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: items.length,
                    onPageChanged: _viewModel.updatePage,
                    itemBuilder: (context, index) {
                      final item = items[index];
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

                Padding(
                  padding: const EdgeInsets.fromLTRB(28, 12, 28, 32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 180),
                        switchInCurve: Curves.easeOutCubic,
                        switchOutCurve: Curves.easeOutCubic,
                        child: isLastPage
                            ? HideOnboardingPreference(
                                key: const ValueKey(
                                  'hide_onboarding_preference',
                                ),
                                value: _viewModel.hideOnboardingNextTime,
                                colors: _colors.hidePreferenceColors,
                                onToggle:
                                    _viewModel.toggleHideOnboardingNextTime,
                              )
                            : const SizedBox.shrink(
                                key: ValueKey('empty_onboarding_preference'),
                              ),
                      ),

                      if (isLastPage) const SizedBox(height: 16),

                      OnboardingBottomControls(
                        currentIndex: _viewModel.currentPage,
                        itemCount: items.length,
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
