enum AppNotificationType {
  /// Ritardi delle linee o delle singole corse.
  delay,

  /// Informazioni utili mentre l'utente sta viaggiando.
  trip,

  /// Modifiche a orari, fermate, linee o viabilità.
  serviceUpdate,
}

///Notifica mostrata nel centro notifiche dell'app.
class AppNotification {
  const AppNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.createdAt,
    this.isRead = false,
  });

  final String id;
  final AppNotificationType type;
  final String title;
  final String message;
  final DateTime createdAt;
  final bool isRead;

AppNotification copyWith({bool? isRead}) => AppNotification(
  id: id,
  type: type,
  title: title,
  message: message,
  createdAt: createdAt,
  isRead: isRead ?? this.isRead,
);
}
