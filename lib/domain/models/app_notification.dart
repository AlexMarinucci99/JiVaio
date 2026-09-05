enum AppNotificationType { delay, trip, serviceUpdate }

///Notifica mostrata nel centro notifiche.
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
