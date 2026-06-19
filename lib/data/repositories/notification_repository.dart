import '../../domain/models/app_notification.dart';
import '../services/notification_service.dart';

/// Gestisce l'accesso ai dati delle notifiche.
///
/// Espone ai ViewModel un'API stabile e indipendente
/// dall'implementazione concreta di [NotificationService].
class NotificationRepository {
  const NotificationRepository({required NotificationService service})
    : _service = service;

  final NotificationService _service;

  Future<List<AppNotification>> getNotifications() {
    return _service.fetchNotifications();
  }
}
