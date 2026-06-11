import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:jivaio/data/repositories/auth_repository.dart';
import 'package:jivaio/ui/auth/view_model/reset_password_view_model.dart';

class FakeAuthRepository implements AuthRepository {
  bool sendPasswordResetEmailCalled = false;
  String? lastEmail;

  FirebaseAuthException? firebaseExceptionToThrow;
  Object? genericExceptionToThrow;

  @override
  Future<void> sendPasswordResetEmail({
    required String email,
  }) async {
    sendPasswordResetEmailCalled = true;
    lastEmail = email;

    final firebaseException = firebaseExceptionToThrow;
    if (firebaseException != null) {
      throw firebaseException;
    }

    final genericException = genericExceptionToThrow;
    if (genericException != null) {
      throw genericException;
    }
  }

  @override
  dynamic noSuchMethod(Invocation invocation) {
    return super.noSuchMethod(invocation);
  }
}

void main() {
  late FakeAuthRepository authRepository;
  late ResetPasswordViewModel viewModel;

  setUp(() {
    authRepository = FakeAuthRepository();
    viewModel = ResetPasswordViewModel(authRepository);
  });

  tearDown(() {
    viewModel.dispose();
  });

  test('inizializza lo stato correttamente', () {
    expect(viewModel.email, isEmpty);
    expect(viewModel.isSubmitting, isFalse);
    expect(viewModel.canSubmit, isFalse);
  });

  test('aggiorna email rimuovendo spazi iniziali e finali', () {
    viewModel.updateEmail('  test@jivaio.it  ');

    expect(viewModel.email, 'test@jivaio.it');
    expect(viewModel.canSubmit, isTrue);
  });

  test('notifica i listener quando cambia email', () {
    var notificationCount = 0;

    viewModel.addListener(() {
      notificationCount++;
    });

    viewModel.updateEmail('utente@jivaio.it');

    expect(notificationCount, 1);
  });

  test('non notifica i listener se email non cambia', () {
    var notificationCount = 0;

    viewModel.updateEmail('utente@jivaio.it');

    viewModel.addListener(() {
      notificationCount++;
    });

    viewModel.updateEmail('utente@jivaio.it');

    expect(notificationCount, 0);
  });

  test('restituisce errore se email vuota', () async {
    final result = await viewModel.sendResetLink();

    expect(result.isSuccess, isFalse);
    expect(result.message, 'Inserisci la tua email');
    expect(authRepository.sendPasswordResetEmailCalled, isFalse);
  });

  test('restituisce errore se email non valida', () async {
    viewModel.updateEmail('email-non-valida');

    final result = await viewModel.sendResetLink();

    expect(result.isSuccess, isFalse);
    expect(result.message, 'Inserisci un indirizzo email valido');
    expect(authRepository.sendPasswordResetEmailCalled, isFalse);
  });

  test('invia il link di recupero con email valida', () async {
    viewModel.updateEmail('utente@jivaio.it');

    final result = await viewModel.sendResetLink();

    expect(result.isSuccess, isTrue);
    expect(
      result.message,
      'Se l’email è associata a un account JiVaio, riceverai un link per reimpostare la password.',
    );
    expect(authRepository.sendPasswordResetEmailCalled, isTrue);
    expect(authRepository.lastEmail, 'utente@jivaio.it');
    expect(viewModel.isSubmitting, isFalse);
  });

  test('gestisce errore Firebase invalid-email', () async {
    viewModel.updateEmail('utente@jivaio.it');

    authRepository.firebaseExceptionToThrow = FirebaseAuthException(
      code: 'invalid-email',
    );

    final result = await viewModel.sendResetLink();

    expect(result.isSuccess, isFalse);
    expect(result.message, 'Inserisci un indirizzo email valido.');
    expect(viewModel.isSubmitting, isFalse);
  });

  test('gestisce errore Firebase network-request-failed', () async {
    viewModel.updateEmail('utente@jivaio.it');

    authRepository.firebaseExceptionToThrow = FirebaseAuthException(
      code: 'network-request-failed',
    );

    final result = await viewModel.sendResetLink();

    expect(result.isSuccess, isFalse);
    expect(result.message, 'Controlla la connessione e riprova.');
    expect(viewModel.isSubmitting, isFalse);
  });

  test('gestisce errore Firebase too-many-requests', () async {
    viewModel.updateEmail('utente@jivaio.it');

    authRepository.firebaseExceptionToThrow = FirebaseAuthException(
      code: 'too-many-requests',
    );

    final result = await viewModel.sendResetLink();

    expect(result.isSuccess, isFalse);
    expect(result.message, 'Troppe richieste in poco tempo. Riprova più tardi.');
    expect(viewModel.isSubmitting, isFalse);
  });

  test('gestisce errore Firebase user-not-found con messaggio sicuro', () async {
    viewModel.updateEmail('utente@jivaio.it');

    authRepository.firebaseExceptionToThrow = FirebaseAuthException(
      code: 'user-not-found',
    );

    final result = await viewModel.sendResetLink();

    expect(result.isSuccess, isFalse);
    expect(
      result.message,
      'Se l’email è associata a un account JiVaio, riceverai un link per reimpostare la password.',
    );
    expect(viewModel.isSubmitting, isFalse);
  });

  test('gestisce errore Firebase generico', () async {
    viewModel.updateEmail('utente@jivaio.it');

    authRepository.firebaseExceptionToThrow = FirebaseAuthException(
      code: 'unknown-error',
    );

    final result = await viewModel.sendResetLink();

    expect(result.isSuccess, isFalse);
    expect(
      result.message,
      'Non è stato possibile inviare il link di recupero. Riprova.',
    );
    expect(viewModel.isSubmitting, isFalse);
  });

  test('gestisce errore generico imprevisto', () async {
    viewModel.updateEmail('utente@jivaio.it');

    authRepository.genericExceptionToThrow = Exception('Errore test');

    final result = await viewModel.sendResetLink();

    expect(result.isSuccess, isFalse);
    expect(
      result.message,
      'Si è verificato un errore imprevisto. Riprova.',
    );
    expect(viewModel.isSubmitting, isFalse);
  });
}