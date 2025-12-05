import 'package:bienestar_integral_app/features/events/domain/entities/event.dart';
import 'package:bienestar_integral_app/features/events/domain/entities/event_participant.dart';
import 'package:bienestar_integral_app/features/events/domain/entities/event_registration.dart';

abstract class EventRepository {
  // Métodos existentes
  Future<List<Event>> getEventsByKitchen(int kitchenId);
  Future<void> registerToEvent(int eventId);
  Future<List<EventRegistration>> getMyRegistrations();
  Future<void> unregisterFromEvent(int eventId);

  // --- MÉTODOS DE ADMIN (NUEVOS) ---
  Future<void> createEvent(Map<String, dynamic> eventData);
  Future<void> updateEvent(int eventId, Map<String, dynamic> eventData);
  Future<void> deleteEvent(int eventId);
  Future<List<EventParticipant>> getEventParticipants(int eventId);
  // Reutilizamos EventParticipant para suscriptores ya que la estructura es similar o creamos uno nuevo si difiere mucho.
  // Basado en tu JSON, subscribers devuelve una estructura simple, pero usaremos participant para estandarizar visualización
  Future<List<EventParticipant>> getKitchenSubscribers(int kitchenId);
}