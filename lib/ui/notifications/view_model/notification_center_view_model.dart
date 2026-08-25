import 'package:flutter/foundation.dart';

import '../../../data/repositories/notification_repository.dart';
import '../../../domain/models/app_notification.dart';

/// Gestisce lo stato e le azioni del centro notifiche.
class NotificationCenterViewModel extends ChangeNotifier {
  NotificationCenterViewModel({required NotificationRepository repository})
    : _repository = repository;

  final NotificationRepository _repository;
  List<AppNotification> _notifications = const [];
  bool _isLoading = false;
  bool _isPanelOpen = false;
  bool _isDisposed = false;

  List<AppNotification> get notifications => _notifications;
  bool get isLoading => _isLoading;
  bool get isPanelOpen => _isPanelOpen;
  int get unreadCount =>
      _notifications.where((notification) => !notification.isRead).length;

  /// Carica le notifiche disponibili e le ordina dalla più recente.
  Future<void> loadNotifications() async {
    if (_isLoading || _notifications.isNotEmpty) {
      return;
    }

    _isLoading = true;
    _notifyListenersSafely();

    try {
      _notifications = List<AppNotification>.unmodifiable(
        (await _repository.getNotifications())..sort(
          (first, second) => second.createdAt.compareTo(first.createdAt),
        ),
      );
} catch (_) {
  _notifications = const [];
} finally {
      _isLoading = false;
      _notifyListenersSafely();
    }
  }

  /// Apre o chiude il pannello delle notifiche.
  void togglePanel() {
    _isPanelOpen = !_isPanelOpen;
    _notifyListenersSafely();
  }

  /// Chiude il pannello delle notifiche, se aperto.
  void closePanel() {
    if (!_isPanelOpen) {
      return;
    }

    _isPanelOpen = false;
    _notifyListenersSafely();
  }

  /// Segna come letta la notifica identificata da [notificationId].
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

  /// Segna come lette tutte le notifiche non ancora lette.
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
