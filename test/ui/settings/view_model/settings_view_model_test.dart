import 'package:flutter_test/flutter_test.dart';

import 'package:jivaio/ui/settings/view_model/settings_view_model.dart';

void main() {
  test('riconosce un utente guest', () {
    const viewModel = SettingsViewModel(
      isGuest: true,
    );

    expect(viewModel.isGuest, isTrue);
  });

  test('riconosce un utente autenticato', () {
    const viewModel = SettingsViewModel(
      isGuest: false,
    );

    expect(viewModel.isGuest, isFalse);
  });

  test('non permette al guest di gestire l’account', () {
    const viewModel = SettingsViewModel(
      isGuest: true,
    );

    expect(viewModel.canManageAccount, isFalse);
  });

  test('permette all’utente autenticato di gestire l’account', () {
    const viewModel = SettingsViewModel(
      isGuest: false,
    );

    expect(viewModel.canManageAccount, isTrue);
  });
}