import 'package:flutter_test/flutter_test.dart';

import 'package:jivaio/data/repositories/notification_repository.dart';
import 'package:jivaio/domain/models/app_notification.dart';
import 'package:jivaio/ui/notifications/view_model/notification_center_view_model.dart';

class FakeNotificationRepository implements NotificationRepository {
  FakeNotificationRepository({
    required this.notifications,
    this.shouldThrow = false,
  });

  final List<AppNotification> notifications;
  final bool shouldThrow;

  int getNotificationsCallCount = 0;

  @override
  Future<List<AppNotification>> getNotifications() async {
    getNotificationsCallCount++;

    if (shouldThrow) {
      throw Exception('Errore test notifiche');
    }

    return List<AppNotification>.of(notifications);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) {
    return super.noSuchMethod(invocation);
  }
}

AppNotification buildNotification({
  required String id,
  required String title,
  required DateTime createdAt,
  bool isRead = false,
  AppNotificationType type = AppNotificationType.serviceUpdate,
}) {
  return AppNotification(
    id: id,
    title: title,
    message: 'Messaggio di test',
    type: type,
    createdAt: createdAt,
    isRead: isRead,
  );
}

void main() {
  group('NotificationCenterViewModel', () {
    test('parte con stato iniziale vuoto', () {
      final repository = FakeNotificationRepository(notifications: const []);

      final viewModel = NotificationCenterViewModel(repository: repository);

      expect(viewModel.notifications, isEmpty);
      expect(viewModel.isLoading, isFalse);
      expect(viewModel.isPanelOpen, isFalse);
      expect(viewModel.errorMessage, isNull);
      expect(viewModel.unreadCount, 0);
      expect(viewModel.hasUnreadNotifications, isFalse);

      viewModel.dispose();
    });

    test('loadNotifications carica le notifiche dal repository', () async {
      final repository = FakeNotificationRepository(
        notifications: [
          buildNotification(
            id: 'notification-1',
            title: 'Ritardo linea 1',
            createdAt: DateTime(2026, 6, 10, 8),
          ),
        ],
      );

      final viewModel = NotificationCenterViewModel(repository: repository);

      await viewModel.loadNotifications();

      expect(repository.getNotificationsCallCount, 1);
      expect(viewModel.notifications.length, 1);
      expect(viewModel.notifications.first.id, 'notification-1');
      expect(viewModel.isLoading, isFalse);
      expect(viewModel.errorMessage, isNull);

      viewModel.dispose();
    });

    test('ordina le notifiche dalla più recente alla meno recente', () async {
      final repository = FakeNotificationRepository(
        notifications: [
          buildNotification(
            id: 'old',
            title: 'Notifica vecchia',
            createdAt: DateTime(2026, 6, 10, 8),
          ),
          buildNotification(
            id: 'recent',
            title: 'Notifica recente',
            createdAt: DateTime(2026, 6, 10, 10),
          ),
          buildNotification(
            id: 'middle',
            title: 'Notifica intermedia',
            createdAt: DateTime(2026, 6, 10, 9),
          ),
        ],
      );

      final viewModel = NotificationCenterViewModel(repository: repository);

      await viewModel.loadNotifications();

      expect(viewModel.notifications[0].id, 'recent');
      expect(viewModel.notifications[1].id, 'middle');
      expect(viewModel.notifications[2].id, 'old');

      viewModel.dispose();
    });

    test('calcola correttamente il numero di notifiche non lette', () async {
      final repository = FakeNotificationRepository(
        notifications: [
          buildNotification(
            id: 'notification-1',
            title: 'Non letta 1',
            createdAt: DateTime(2026, 6, 10, 8),
            isRead: false,
          ),
          buildNotification(
            id: 'notification-2',
            title: 'Letta',
            createdAt: DateTime(2026, 6, 10, 9),
            isRead: true,
          ),
          buildNotification(
            id: 'notification-3',
            title: 'Non letta 2',
            createdAt: DateTime(2026, 6, 10, 10),
            isRead: false,
          ),
        ],
      );

      final viewModel = NotificationCenterViewModel(repository: repository);

      await viewModel.loadNotifications();

      expect(viewModel.unreadCount, 2);
      expect(viewModel.hasUnreadNotifications, isTrue);

      viewModel.dispose();
    });

    test('togglePanel apre e chiude il pannello', () {
      final repository = FakeNotificationRepository(notifications: const []);

      final viewModel = NotificationCenterViewModel(repository: repository);

      expect(viewModel.isPanelOpen, isFalse);

      viewModel.togglePanel();
      expect(viewModel.isPanelOpen, isTrue);

      viewModel.togglePanel();
      expect(viewModel.isPanelOpen, isFalse);

      viewModel.dispose();
    });

    test('closePanel chiude il pannello solo se è aperto', () {
      final repository = FakeNotificationRepository(notifications: const []);

      final viewModel = NotificationCenterViewModel(repository: repository);

      viewModel.closePanel();
      expect(viewModel.isPanelOpen, isFalse);

      viewModel.togglePanel();
      expect(viewModel.isPanelOpen, isTrue);

      viewModel.closePanel();
      expect(viewModel.isPanelOpen, isFalse);

      viewModel.dispose();
    });

    test('markAsRead segna una singola notifica come letta', () async {
      final repository = FakeNotificationRepository(
        notifications: [
          buildNotification(
            id: 'notification-1',
            title: 'Ritardo linea 1',
            createdAt: DateTime(2026, 6, 10, 8),
            isRead: false,
          ),
          buildNotification(
            id: 'notification-2',
            title: 'Cambio fermata',
            createdAt: DateTime(2026, 6, 10, 9),
            isRead: false,
          ),
        ],
      );

      final viewModel = NotificationCenterViewModel(repository: repository);

      await viewModel.loadNotifications();

      viewModel.markAsRead('notification-1');

      final updatedNotification = viewModel.notifications.firstWhere(
        (notification) => notification.id == 'notification-1',
      );

      final otherNotification = viewModel.notifications.firstWhere(
        (notification) => notification.id == 'notification-2',
      );

      expect(updatedNotification.isRead, isTrue);
      expect(otherNotification.isRead, isFalse);
      expect(viewModel.unreadCount, 1);

      viewModel.dispose();
    });

    test('markAsRead non modifica nulla se id non esiste', () async {
      final repository = FakeNotificationRepository(
        notifications: [
          buildNotification(
            id: 'notification-1',
            title: 'Ritardo linea 1',
            createdAt: DateTime(2026, 6, 10, 8),
            isRead: false,
          ),
        ],
      );

      final viewModel = NotificationCenterViewModel(repository: repository);

      await viewModel.loadNotifications();

      viewModel.markAsRead('id-non-esistente');

      expect(viewModel.notifications.first.isRead, isFalse);
      expect(viewModel.unreadCount, 1);

      viewModel.dispose();
    });

    test('markAllAsRead segna tutte le notifiche come lette', () async {
      final repository = FakeNotificationRepository(
        notifications: [
          buildNotification(
            id: 'notification-1',
            title: 'Ritardo linea 1',
            createdAt: DateTime(2026, 6, 10, 8),
            isRead: false,
          ),
          buildNotification(
            id: 'notification-2',
            title: 'Cambio fermata',
            createdAt: DateTime(2026, 6, 10, 9),
            isRead: false,
          ),
        ],
      );

      final viewModel = NotificationCenterViewModel(repository: repository);

      await viewModel.loadNotifications();

      viewModel.markAllAsRead();

      expect(
        viewModel.notifications.every((notification) => notification.isRead),
        isTrue,
      );
      expect(viewModel.unreadCount, 0);
      expect(viewModel.hasUnreadNotifications, isFalse);

      viewModel.dispose();
    });

    test(
      'loadNotifications non ricarica se le notifiche sono già presenti',
      () async {
        final repository = FakeNotificationRepository(
          notifications: [
            buildNotification(
              id: 'notification-1',
              title: 'Ritardo linea 1',
              createdAt: DateTime(2026, 6, 10, 8),
            ),
          ],
        );

        final viewModel = NotificationCenterViewModel(repository: repository);

        await viewModel.loadNotifications();
        await viewModel.loadNotifications();

        expect(repository.getNotificationsCallCount, 1);

        viewModel.dispose();
      },
    );

    test('gestisce errore durante il caricamento notifiche', () async {
      final repository = FakeNotificationRepository(
        notifications: const [],
        shouldThrow: true,
      );

      final viewModel = NotificationCenterViewModel(repository: repository);

      await viewModel.loadNotifications();

      expect(viewModel.notifications, isEmpty);
      expect(viewModel.isLoading, isFalse);
      expect(viewModel.errorMessage, 'Impossibile caricare le notifiche.');

      viewModel.dispose();
    });

    test('notifica i listener durante il caricamento', () async {
      final repository = FakeNotificationRepository(
        notifications: [
          buildNotification(
            id: 'notification-1',
            title: 'Ritardo linea 1',
            createdAt: DateTime(2026, 6, 10, 8),
          ),
        ],
      );

      final viewModel = NotificationCenterViewModel(repository: repository);

      var notifyCount = 0;

      viewModel.addListener(() {
        notifyCount++;
      });

      await viewModel.loadNotifications();

      expect(notifyCount, 2);

      viewModel.dispose();
    });
  });
}
