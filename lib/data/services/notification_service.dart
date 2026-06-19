import '../../domain/models/app_notification.dart';

/// Definisce il contratto per le sorgenti dati delle notifiche.
///
/// Il repository dipende da questa astrazione invece che da una sorgente
/// concreta, così le notifiche possono arrivare da mock, Firebase,
/// Supabase o API REST senza modificare UI e ViewModel.
abstract class NotificationService {
  Future<List<AppNotification>> fetchNotifications();
}
