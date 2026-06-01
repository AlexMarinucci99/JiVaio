import 'package:flutter/foundation.dart';

import '../../../data/repositories/notification_repository.dart';
import '../../../domain/models/app_notification.dart';

/// Gestisce lo stato e le azioni del centro notifiche.
///
/// La UI legge i dati esposti da questa classe e richiama i suoi metodi
/// quando l'utente apre il pannello oppure segna gli avvisi come letti.
class NotificationCenterViewModel extends ChangeNotifier {
  NotificationCenterViewModel({required NotificationRepository repository})
    : _repository = repository;

  final NotificationRepository _repository;

  List<AppNotification> _notifications = const [];

  bool _isLoading = false;
  bool _isPanelOpen = false;
  bool _isDisposed = false;

  String? _errorMessage;

  List<AppNotification> get notifications => _notifications;

  bool get isLoading => _isLoading;

  bool get isPanelOpen => _isPanelOpen;

  String? get errorMessage => _errorMessage;

  int get unreadCount {
    return _notifications.where((notification) => !notification.isRead).length;
  }

  bool get hasUnreadNotifications => unreadCount > 0;

  Future<void> loadNotifications() async {
    if (_isLoading || _notifications.isNotEmpty) {
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    _notifyListenersSafely();

    try {
      final notifications = await _repository.getNotifications();

      // Mostra prima gli avvisi più recenti.
      notifications.sort(
        (first, second) => second.createdAt.compareTo(first.createdAt),
      );

      _notifications = List<AppNotification>.unmodifiable(notifications);
    } catch (_) {
      _errorMessage = 'Impossibile caricare le notifiche.';
    } finally {
      _isLoading = false;
      _notifyListenersSafely();
    }
  }

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

    final updatedNotifications = List<AppNotification>.of(_notifications);

    updatedNotifications[notificationIndex] =
        updatedNotifications[notificationIndex].copyWith(isRead: true);

    _notifications = List<AppNotification>.unmodifiable(updatedNotifications);

    _notifyListenersSafely();
  }

  void markAllAsRead() {
    if (!hasUnreadNotifications) {
      return;
    }

    _notifications = List<AppNotification>.unmodifiable(
      _notifications.map((notification) {
        if (notification.isRead) {
          return notification;
        }

        return notification.copyWith(isRead: true);
      }),
    );

    _notifyListenersSafely();
  }

  void _notifyListenersSafely() {
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
