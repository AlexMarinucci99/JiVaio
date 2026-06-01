import '../../domain/models/app_notification.dart';

// Sorgente dati temporanea per il centro notifiche.
//
// In questa prima versione restituisce notifiche create manualmente.
// In futuro potrà essere sostituita da un service collegato a Firebase,
// Supabase oppure a una API REST senza modificare la UI.
class MockNotificationService {
  const MockNotificationService();

  Future<List<AppNotification>> fetchNotifications() async {
    // Piccolo ritardo artificiale per simulare il recupero dei dati
    // da una sorgente remota o da un database.
    await Future<void>.delayed(const Duration(milliseconds: 250));

    final now = DateTime.now();

    return [
      AppNotification(
        id: 'delay-line-1',
        type: AppNotificationType.delay,
        title: 'Ritardo sulla Linea 1',
        message:
            'La corsa prevista alle 18:20 registra circa 8 minuti di ritardo.',
        createdAt: now.subtract(const Duration(minutes: 6)),
      ),
      AppNotification(
        id: 'trip-terminal-bus',
        type: AppNotificationType.trip,
        title: 'Preparati a scendere',
        message: 'La fermata Terminal Bus è prevista tra 2 fermate.',
        createdAt: now.subtract(const Duration(minutes: 2)),
      ),
      AppNotification(
        id: 'service-update-via-xx-settembre',
        type: AppNotificationType.serviceUpdate,
        title: 'Modifica temporanea della viabilità',
        message:
            'A causa di lavori , la fermata di Via XX Settembre è temporaneamente sospesa.',
        createdAt: now.subtract(const Duration(hours: 1)),
      ),
    ];
  }
}
