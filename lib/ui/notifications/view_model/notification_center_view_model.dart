import 'package:flutter/foundation.dart';

import '../../../data/repositories/notification_repository.dart';
import '../../../domain/models/app_notification.dart';

/// Gestisce lo stato e le azioni del centro notifiche.
class NotificationCenterViewModel extends ChangeNotifier {
  NotificationCenterViewModel({required NotificationRepository repository})
    : _repository = repository;

  final NotificationRepository _repository;
  List<AppNotification> _notifications = const [];
  bool _isPanelOpen = false;
  bool _isDisposed = false;

  List<AppNotification> get notifications => _notifications;
  bool get isPanelOpen => _isPanelOpen;
  int get unreadCount =>
      _notifications.where((notification) => !notification.isRead).length;

  /// Carica le notifiche e le ordina.
  Future<void> loadNotifications() async {
    if (_notifications.isNotEmpty) {
      return;
    }

    try {
      _notifications = List<AppNotification>.unmodifiable(
        (await _repository.getNotifications())..sort(
          (first, second) => second.createdAt.compareTo(first.createdAt),
        ),
      );
    } catch (_) {
      _notifications = const [];
    }

    _notifyListenersSafely();
  }

  /// Apre o chiude il pannello delle notifiche.
  void togglePanel() {
    _isPanelOpen = !_isPanelOpen;
    _notifyListenersSafely();
  }

  void closePanel() {
    if (!_isPanelOpen) {
      return;
    }

    _isPanelOpen = false;
    _notifyListenersSafely();
  }

  void markAsRead(String notificationId) {
    final notificationIndex = _notifications.indexWhere(
      (notification) => notification.id == notificationId,
    );

    if (notificationIndex == -1 || _notifications[notificationIndex].isRead) {
      return;
    }

    _notifications = List<AppNotification>.unmodifiable(
      List<AppNotification>.of(_notifications)
        ..[notificationIndex] = _notifications[notificationIndex].copyWith(
          isRead: true,
        ),
    );

    _notifyListenersSafely();
  }

  void markAllAsRead() {
    if (unreadCount == 0) {
      return;
    }

    _notifications = List<AppNotification>.unmodifiable(
      _notifications.map(
        (notification) => notification.isRead
            ? notification
            : notification.copyWith(isRead: true),
      ),
    );

    _notifyListenersSafely();
  }

  void _notifyListenersSafely() {
    // Evita notifiche dopo dispose durante operazioni asincrone ancora attive.
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
