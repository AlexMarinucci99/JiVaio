import 'package:flutter_test/flutter_test.dart';

import 'package:jivaio/domain/models/app_notification.dart';

void main() {
  group('AppNotification', () {
    test('mantiene correttamente i dati ricevuti nel costruttore', () {
      final createdAt = DateTime(2026, 6, 10, 8, 30);

      final notification = AppNotification(
        id: 'notification-1',
        title: 'Ritardo linea 1',
        message: 'La linea 1 potrebbe subire un ritardo di 10 minuti.',
        type: AppNotificationType.delay,
        createdAt: createdAt,
        isRead: false,
      );

      expect(notification.id, 'notification-1');
      expect(notification.title, 'Ritardo linea 1');
      expect(
        notification.message,
        'La linea 1 potrebbe subire un ritardo di 10 minuti.',
      );
      expect(notification.type, AppNotificationType.delay);
      expect(notification.createdAt, createdAt);
      expect(notification.isRead, isFalse);
    });

    test('supporta il tipo delay', () {
      final notification = AppNotification(
        id: 'notification-delay',
        title: 'Ritardo',
        message: 'La corsa è in ritardo.',
        type: AppNotificationType.delay,
        createdAt: DateTime(2026, 6, 10),
        isRead: false,
      );

      expect(notification.type, AppNotificationType.delay);
    });

    test('supporta il tipo trip', () {
      final notification = AppNotification(
        id: 'notification-trip',
        title: 'Viaggio',
        message: 'Hai una notifica relativa al viaggio.',
        type: AppNotificationType.trip,
        createdAt: DateTime(2026, 6, 10),
        isRead: false,
      );

      expect(notification.type, AppNotificationType.trip);
    });

    test('supporta il tipo serviceUpdate', () {
      final notification = AppNotification(
        id: 'notification-service',
        title: 'Aggiornamento servizio',
        message: 'La fermata è temporaneamente spostata.',
        type: AppNotificationType.serviceUpdate,
        createdAt: DateTime(2026, 6, 10),
        isRead: false,
      );

      expect(notification.type, AppNotificationType.serviceUpdate);
    });

    test('copyWith aggiorna isRead senza modificare gli altri dati', () {
      final createdAt = DateTime(2026, 6, 10, 8, 30);

      final notification = AppNotification(
        id: 'notification-1',
        title: 'Ritardo linea 1',
        message: 'La linea 1 potrebbe subire un ritardo di 10 minuti.',
        type: AppNotificationType.delay,
        createdAt: createdAt,
        isRead: false,
      );

      final updatedNotification = notification.copyWith(
        isRead: true,
      );

      expect(updatedNotification.id, notification.id);
      expect(updatedNotification.title, notification.title);
      expect(updatedNotification.message, notification.message);
      expect(updatedNotification.type, notification.type);
      expect(updatedNotification.createdAt, notification.createdAt);
      expect(updatedNotification.isRead, isTrue);
    });

    test('copyWith non modifica l’istanza originale', () {
      final notification = AppNotification(
        id: 'notification-1',
        title: 'Ritardo linea 1',
        message: 'La linea 1 potrebbe subire un ritardo di 10 minuti.',
        type: AppNotificationType.delay,
        createdAt: DateTime(2026, 6, 10),
        isRead: false,
      );

      final updatedNotification = notification.copyWith(
        isRead: true,
      );

      expect(notification.isRead, isFalse);
      expect(updatedNotification.isRead, isTrue);
    });
  });
}