import 'package:flutter_test/flutter_test.dart';

import 'package:jivaio/ui/onboarding/view_model/onboarding_view_model.dart';

import '../../../helpers/fakes/fake_onboarding_repository.dart';

void main() {
  late FakeOnboardingRepository onboardingRepository;
  late OnboardingViewModel viewModel;

  setUp(() {
    onboardingRepository = FakeOnboardingRepository();

    viewModel = OnboardingViewModel(onboardingRepository: onboardingRepository);
  });

  tearDown(() {
    viewModel.dispose();
  });

  test('parte dalla prima pagina', () {
    expect(viewModel.currentPage, 0);
    expect(viewModel.isLastPage, isFalse);
    expect(viewModel.hideOnboardingNextTime, isFalse);
  });

  test('contiene le tre slide di onboarding previste', () {
    expect(viewModel.items.length, 3);

    expect(viewModel.items[0].title, 'Trova la tua Fermata');
    expect(viewModel.items[1].title, 'Orari a portata di mano');
    expect(viewModel.items[2].title, 'Viaggia con più semplicità');
  });

  test('ogni slide contiene immagine, titolo e descrizione', () {
    for (final item in viewModel.items) {
      expect(item.imagePath.trim(), isNotEmpty);
      expect(item.title.trim(), isNotEmpty);
      expect(item.description.trim(), isNotEmpty);
    }
  });

  test('updatePage aggiorna la pagina corrente', () {
    viewModel.updatePage(1);

    expect(viewModel.currentPage, 1);
    expect(viewModel.isLastPage, isFalse);
  });

  test('isLastPage diventa true quando si arriva all’ultima slide', () {
    viewModel.updatePage(2);

    expect(viewModel.currentPage, 2);
    expect(viewModel.isLastPage, isTrue);
  });

  test('notifica i listener quando cambia pagina', () {
    var notifyCount = 0;

    viewModel.addListener(() {
      notifyCount++;
    });

    viewModel.updatePage(1);

    expect(notifyCount, 1);
  });

  test('non notifica i listener se la pagina è già quella corrente', () {
    var notifyCount = 0;

    viewModel.addListener(() {
      notifyCount++;
    });

    viewModel.updatePage(0);

    expect(viewModel.currentPage, 0);
    expect(notifyCount, 0);
  });

  test('può avanzare e tornare logicamente tra le pagine', () {
    viewModel.updatePage(1);
    expect(viewModel.currentPage, 1);

    viewModel.updatePage(2);
    expect(viewModel.currentPage, 2);
    expect(viewModel.isLastPage, isTrue);

    viewModel.updatePage(0);
    expect(viewModel.currentPage, 0);
    expect(viewModel.isLastPage, isFalse);
  });

  test('toggleHideOnboardingNextTime aggiorna la preferenza', () {
    expect(viewModel.hideOnboardingNextTime, isFalse);

    viewModel.toggleHideOnboardingNextTime();

    expect(viewModel.hideOnboardingNextTime, isTrue);

    viewModel.toggleHideOnboardingNextTime();

    expect(viewModel.hideOnboardingNextTime, isFalse);
  });

  test('toggleHideOnboardingNextTime notifica i listener', () {
    var notifyCount = 0;

    viewModel.addListener(() {
      notifyCount++;
    });

    viewModel.toggleHideOnboardingNextTime();

    expect(notifyCount, 1);
  });

  test(
    'completeOnboarding salva false quando la preferenza non è selezionata',
    () async {
      await viewModel.completeOnboarding();

      expect(onboardingRepository.setSkipOnboardingCallCount, 1);
      expect(onboardingRepository.lastSkipOnboardingValue, isFalse);
    },
  );

  test(
    'completeOnboarding salva true quando la preferenza è selezionata',
    () async {
      viewModel.toggleHideOnboardingNextTime();

      await viewModel.completeOnboarding();

      expect(onboardingRepository.setSkipOnboardingCallCount, 1);
      expect(onboardingRepository.lastSkipOnboardingValue, isTrue);
    },
  );

  test('skipOnboarding non salva prima dell’ultima pagina', () async {
    await viewModel.skipOnboarding();

    expect(onboardingRepository.setSkipOnboardingCallCount, 0);
    expect(onboardingRepository.lastSkipOnboardingValue, isNull);
  });

  test('skipOnboarding completa il salvataggio nell’ultima pagina', () async {
    viewModel.updatePage(2);
    viewModel.toggleHideOnboardingNextTime();

    await viewModel.skipOnboarding();

    expect(viewModel.isLastPage, isTrue);
    expect(onboardingRepository.setSkipOnboardingCallCount, 1);
    expect(onboardingRepository.lastSkipOnboardingValue, isTrue);
  });
}
