import 'package:flutter/material.dart';

import '../theme/onboarding_colors.dart';

/// Indicatore delle pagine dell'onboarding.
class OnboardingDotsIndicator extends StatelessWidget {
  const OnboardingDotsIndicator({
    super.key,
    required this.currentIndex,
    required this.itemCount,
  });

  final int currentIndex;
  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(itemCount, (index) {
        final isActive = index == currentIndex;

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          width: isActive ? 26 : 9,
          height: 9,
          decoration: BoxDecoration(
            color: isActive
                ? OnboardingColors.primary
                : OnboardingColors.inactiveDot,
            borderRadius: BorderRadius.circular(99),
          ),
        );
      }),
    );
  }
}
