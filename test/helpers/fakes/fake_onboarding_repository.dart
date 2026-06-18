import 'package:jivaio/data/repositories/onboarding_repository.dart';

class FakeOnboardingRepository implements OnboardingRepository {
  bool? lastSkipOnboardingValue;
  int setSkipOnboardingCallCount = 0;

  @override
  Future<void> setSkipOnboarding(bool shouldSkip) async {
    lastSkipOnboardingValue = shouldSkip;
    setSkipOnboardingCallCount++;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) {
    return super.noSuchMethod(invocation);
  }
}