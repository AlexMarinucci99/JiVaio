import 'package:flutter_test/flutter_test.dart';

import 'package:jivaio/data/repositories/auth_repository.dart';
import 'package:jivaio/ui/auth/view_model/auth_view_model.dart';

class FakeAuthRepository implements AuthRepository {
  int invocationCount = 0;

  @override
  dynamic noSuchMethod(Invocation invocation) {
    invocationCount++;
    return super.noSuchMethod(invocation);
  }
}

void main() {
  late FakeAuthRepository repository;
  late AuthViewModel viewModel;

  setUp(() {
    repository = FakeAuthRepository();
    viewModel = AuthViewModel(repository);
  });

  tearDown(() {
    viewModel.dispose();
  });

  test('parte in modalità login', () {
    expect(viewModel.selectedMode, AuthMode.login);
    expect(viewModel.isLogin, isTrue);
    expect(viewModel.isSubmitting, isFalse);
  });

  test('espone i testi corretti per la modalità login', () {
    expect(viewModel.formTitle, 'Bentornato');
    expect(
      viewModel.formSubtitle,
      'Accedi per salvare linee e ricevere notifiche.',
    );
    expect(viewModel.primaryButtonText, 'Accedi');
  });

  test('passa alla modalità registrazione', () {
    viewModel.setMode(AuthMode.register);

    expect(viewModel.selectedMode, AuthMode.register);
    expect(viewModel.isLogin, isFalse);
  });

  test('espone i testi corretti per la modalità registrazione', () {
    viewModel.setMode(AuthMode.register);

    expect(viewModel.formTitle, 'Crea account');
    expect(
      viewModel.formSubtitle,
      'Registrati per personalizzare la tua esperienza.',
    );
    expect(viewModel.primaryButtonText, 'Registrati');
  });

  test('notifica i listener quando cambia modalità', () {
    var notifyCount = 0;

    viewModel.addListener(() {
      notifyCount++;
    });

    viewModel.setMode(AuthMode.register);

    expect(notifyCount, 1);
  });

  test('non notifica i listener se la modalità è già quella corrente', () {
    var notifyCount = 0;

    viewModel.addListener(() {
      notifyCount++;
    });

    viewModel.setMode(AuthMode.login);

    expect(notifyCount, 0);
  });

  test('togglePasswordVisibility cambia visibilità password', () {
    expect(viewModel.obscurePassword, isTrue);

    viewModel.togglePasswordVisibility();

    expect(viewModel.obscurePassword, isFalse);

    viewModel.togglePasswordVisibility();

    expect(viewModel.obscurePassword, isTrue);
  });

  test('toggleConfirmPasswordVisibility cambia visibilità conferma password', () {
    expect(viewModel.obscureConfirmPassword, isTrue);

    viewModel.toggleConfirmPasswordVisibility();

    expect(viewModel.obscureConfirmPassword, isFalse);

    viewModel.toggleConfirmPasswordVisibility();

    expect(viewModel.obscureConfirmPassword, isTrue);
  });

  test('validateSubmit login fallisce se email o password sono vuote', () {
    final result = viewModel.validateSubmit(
      name: '',
      email: '',
      password: '',
      confirmPassword: '',
    );

    expect(result.isValid, isFalse);
    expect(result.message, 'Inserisci email e password');
  });

  test('validateSubmit login fallisce con email non valida', () {
    final result = viewModel.validateSubmit(
      name: '',
      email: 'utente-non-valido',
      password: 'password123',
      confirmPassword: '',
    );

    expect(result.isValid, isFalse);
    expect(result.message, 'Inserisci un indirizzo email valido');
  });

  test('validateSubmit login passa con email e password valide', () {
    final result = viewModel.validateSubmit(
      name: '',
      email: 'utente@test.it',
      password: 'password123',
      confirmPassword: '',
    );

    expect(result.isValid, isTrue);
    expect(result.message, isNull);
  });

  test('validateSubmit registrazione fallisce se ci sono campi vuoti', () {
    viewModel.setMode(AuthMode.register);

    final result = viewModel.validateSubmit(
      name: '',
      email: 'utente@test.it',
      password: 'password123',
      confirmPassword: 'password123',
    );

    expect(result.isValid, isFalse);
    expect(result.message, 'Compila tutti i campi');
  });

  test('validateSubmit registrazione fallisce con email non valida', () {
    viewModel.setMode(AuthMode.register);

    final result = viewModel.validateSubmit(
      name: 'Mario Rossi',
      email: 'utente-non-valido',
      password: 'password123',
      confirmPassword: 'password123',
    );

    expect(result.isValid, isFalse);
    expect(result.message, 'Inserisci un indirizzo email valido');
  });

  test('validateSubmit registrazione fallisce con password troppo corta', () {
    viewModel.setMode(AuthMode.register);

    final result = viewModel.validateSubmit(
      name: 'Mario Rossi',
      email: 'utente@test.it',
      password: '123',
      confirmPassword: '123',
    );

    expect(result.isValid, isFalse);
    expect(result.message, 'La password deve contenere almeno 6 caratteri');
  });

  test('validateSubmit registrazione fallisce se le password non coincidono', () {
    viewModel.setMode(AuthMode.register);

    final result = viewModel.validateSubmit(
      name: 'Mario Rossi',
      email: 'utente@test.it',
      password: 'password123',
      confirmPassword: 'password456',
    );

    expect(result.isValid, isFalse);
    expect(result.message, 'Le password non coincidono');
  });

  test('validateSubmit registrazione passa con dati validi', () {
    viewModel.setMode(AuthMode.register);

    final result = viewModel.validateSubmit(
      name: 'Mario Rossi',
      email: 'utente@test.it',
      password: 'password123',
      confirmPassword: 'password123',
    );

    expect(result.isValid, isTrue);
    expect(result.message, isNull);
  });

  test('socialLoginMessage restituisce messaggio funzione non implementata', () {
    final message = viewModel.socialLoginMessage('Google');

    expect(message, 'Accesso con Google non ancora implementato');
  });

  test('submit non chiama il repository se la validazione fallisce', () async {
    final result = await viewModel.submit(
      name: '',
      email: '',
      password: '',
      confirmPassword: '',
    );

    expect(result.isValid, isFalse);
    expect(result.message, 'Inserisci email e password');
    expect(repository.invocationCount, 0);
  });
}