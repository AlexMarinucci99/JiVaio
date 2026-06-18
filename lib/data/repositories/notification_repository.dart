import '../../domain/models/app_notification.dart';
import '../services/notification_service.dart';

/// Espone al ViewModel operazioni orientate al dominio delle notifiche.
///
/// Il ViewModel non deve conoscere la sorgente concreta dei dati.
/// Il repository dipende dal contratto [NotificationService],
/// mentre l'implementazione concreta viene scelta in AppDependencies.
class NotificationRepository {
  const NotificationRepository({required NotificationService service})
    : _service = service;

  final NotificationService _service;

  Future<List<AppNotification>> getNotifications() {
    return _service.fetchNotifications();
  }
}
