import 'package:flutter_test/flutter_test.dart';

import 'package:jivaio/ui/onboarding/view_model/onboarding_view_model.dart';

void main() {
  late OnboardingViewModel viewModel;

  setUp(() {
    viewModel = OnboardingViewModel();
  });

  tearDown(() {
    viewModel.dispose();
  });

  test('parte dalla prima pagina', () {
    expect(viewModel.currentPage, 0);
    expect(viewModel.isLastPage, isFalse);
  });

  test('contiene le tre slide di onboarding previste', () {
    expect(viewModel.items.length, 3);

    expect(viewModel.items[0].title, 'Trova la tua Fermata');
    expect(viewModel.items[1].title, 'Orari a portata di mano');
    expect(viewModel.items[2].title, 'Viaggia con più semplicità');
  });

  test('ogni slide contiene immagine, titolo e descrizione', () {
    for (final item in viewModel.items) {
      expect(item.imagePath.trim().isNotEmpty, isTrue);
      expect(item.title.trim().isNotEmpty, isTrue);
      expect(item.description.trim().isNotEmpty, isTrue);
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
}