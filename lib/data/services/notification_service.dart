import '../../domain/models/app_notification.dart';

/// Contratto per le sorgenti dati delle notifiche.
///
/// La UI e il ViewModel non devono sapere se le notifiche arrivano
/// da dati mock, Firebase, Supabase o API REST.
abstract class NotificationService {
  Future<List<AppNotification>> fetchNotifications();
}
