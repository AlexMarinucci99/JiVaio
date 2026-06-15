import 'package:flutter_test/flutter_test.dart';

import 'package:jivaio/domain/models/app_user.dart';
import 'package:jivaio/ui/settings/view_model/settings_view_model.dart';

void main() {
  group('SettingsViewModel', () {
    test('riconosce un utente guest', () {
      const viewModel = SettingsViewModel(user: null);

      expect(viewModel.isGuest, isTrue);
    });

    test('riconosce un utente autenticato', () {
      const user = AppUser(
        id: 'test-user-id',
        email: 'utente@test.it',
        displayName: 'Utente Test',
      );

      const viewModel = SettingsViewModel(user: user);

      expect(viewModel.isGuest, isFalse);
    });

    test('non permette al guest di gestire l’account', () {
      const viewModel = SettingsViewModel(user: null);

      expect(viewModel.canManageAccount, isFalse);
    });

    test('permette all’utente autenticato di gestire l’account', () {
      const user = AppUser(
        id: 'test-user-id',
        email: 'utente@test.it',
        displayName: 'Utente Test',
      );

      const viewModel = SettingsViewModel(user: user);

      expect(viewModel.canManageAccount, isTrue);
    });

    test('mostra titolo e descrizione della modalità guest', () {
      const viewModel = SettingsViewModel(user: null);

      expect(viewModel.profileTitle, 'Modalità ospite');
      expect(
        viewModel.profileSubtitle,
        'Accedi per personalizzare la tua esperienza.',
      );
    });

    test('espone nome ed email dell’utente autenticato', () {
      const user = AppUser(
        id: 'test-user-id',
        email: 'utente@test.it',
        displayName: 'Utente Test',
      );

      const viewModel = SettingsViewModel(user: user);

      expect(viewModel.profileTitle, 'Utente Test');
      expect(viewModel.profileSubtitle, 'utente@test.it');
    });

    test('usa valori di fallback quando nome ed email non sono presenti', () {
      const user = AppUser(id: 'test-user-id');

      const viewModel = SettingsViewModel(user: user);

      expect(viewModel.profileTitle, 'Account personale');
      expect(viewModel.profileSubtitle, 'Account autenticato');
    });

    test('ignora nome ed email composti soltanto da spazi', () {
      const user = AppUser(
        id: 'test-user-id',
        email: '   ',
        displayName: '   ',
      );

      const viewModel = SettingsViewModel(user: user);

      expect(viewModel.profileTitle, 'Account personale');
      expect(viewModel.profileSubtitle, 'Account autenticato');
    });
  });
}
