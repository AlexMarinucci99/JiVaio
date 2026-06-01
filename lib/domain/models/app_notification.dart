enum AppNotificationType {
  // Ritardi delle linee o delle singole corse.
  delay,

  // Informazioni utili mentre l'utente sta viaggiando.
  trip,

  // Modifiche a orari, fermate, linee o viabilità.
  serviceUpdate,
}

class AppNotification {
  const AppNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.createdAt,
    this.isRead = false,
  });

  // Identificativo univoco della notifica.
  final String id;

  // Categoria della notifica.
  final AppNotificationType type;

  // Titolo breve mostrato nel pannello.
  final String title;

  // Descrizione completa dell'avviso.
  final String message;

  // Data e ora di generazione.
  final DateTime createdAt;

  // true quando l'utente ha già aperto la notifica.
  final bool isRead;

  AppNotification copyWith({
    String? id,
    AppNotificationType? type,
    String? title,
    String? message,
    DateTime? createdAt,
    bool? isRead,
  }) {
    return AppNotification(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      message: message ?? this.message,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
    );
  }
}
