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
  //pagecontroller per gestire lo scorrimente delle pagine
  final PageController _pageController = PageController();
  final OnboardingViewModel _viewModel = OnboardingViewModel();

  void _goNext() {
    if (_viewModel.isLastPage) {
      Navigator.pushReplacementNamed(context, AppRoutes.authChoice);
      return;
    }

    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
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
          body: SafeArea(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _skip,
                    child: const Text('Salta'),
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _viewModel.items.length,
                    onPageChanged: _viewModel.updatePage,
                    itemBuilder: (context, index) {
                      return OnboardingPage(
                        item: _viewModel.items[index],
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
                    child: ElevatedButton(
                      onPressed: _goNext,
                      child: Text(
                        _viewModel.isLastPage ? 'Inizia' : 'Avanti',
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