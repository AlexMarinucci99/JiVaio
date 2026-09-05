import '../../domain/models/app_notification.dart';

/// Definisce il contratto per le sorgenti dati delle notifiche.
///
/// Il repository dipende da questa astrazione mock.
abstract class NotificationService {
  Future<List<AppNotification>> fetchNotifications();
}
