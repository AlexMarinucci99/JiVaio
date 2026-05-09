import 'package:flutter/material.dart';

import '../../../routing/app_routes.dart';
import '../view_model/onboarding_view_model.dart';
import 'onboarding_dots_indicator.dart';
import 'onboarding_slide_card.dart';

//Statefulwidget ,come è la scherma principale e contine le 3 pagine di onboarding
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  final OnboardingViewModel _viewModel = OnboardingViewModel();

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
      icon: Icons.directions_bus_rounded,
      accentColor: Color(0xFFFFB020),
      imageAlignment: Alignment.topCenter,
    ),
  ];

  void _goNext() {
    if (_viewModel.isLastPage) {
      Navigator.pushReplacementNamed(context, AppRoutes.authChoice);
      return;
    }

    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }

  void _skip() {
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
          backgroundColor: const Color(0xFFF7F9FC),
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: _skip,
                      child: const Text('Salta'),
                    ),
                  ),
                ),

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
                      );
                    },
                  ),
                ),

                OnboardingDotsIndicator(
                  currentIndex: _viewModel.currentPage,
                  itemCount: _viewModel.items.length,
                ),

                const SizedBox(height: 24),

                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _goNext,
                      style: ElevatedButton.styleFrom(
                        
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        _viewModel.isLastPage ? 'Inizia' : 'Avanti',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
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