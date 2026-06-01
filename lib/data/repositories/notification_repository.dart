import '../../domain/models/app_notification.dart';
import '../services/mock_notification_service.dart';

/// Espone al ViewModel operazioni orientate al dominio delle notifiche.
///
/// Il ViewModel non deve conoscere la sorgente concreta dei dati:
/// attualmente utilizziamo un service mock, ma in futuro potremo
/// sostituirlo con Firebase, Supabase oppure una API REST.
class NotificationRepository {
  const NotificationRepository({
    MockNotificationService service = const MockNotificationService(),
  }) : _service = service;

  final MockNotificationService _service;

  Future<List<AppNotification>> getNotifications() {
    return _service.fetchNotifications();
  }
}
