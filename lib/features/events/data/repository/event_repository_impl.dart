import 'package:bienestar_integral_app/features/events/data/datasource/event_datasource.dart';
import 'package:bienestar_integral_app/features/events/domain/entities/event.dart';
import 'package:bienestar_integral_app/features/events/domain/entities/event_participant.dart';
import 'package:bienestar_integral_app/features/events/domain/entities/event_registration.dart';
import 'package:bienestar_integral_app/features/events/domain/repository/event_repository.dart';

class EventRepositoryImpl implements EventRepository {
  final EventDatasource datasource;

  EventRepositoryImpl({required this.datasource});

  // Existentes
  @override
  Future<List<Event>> getEventsByKitchen(int kitchenId) async => await datasource.getEventsByKitchen(kitchenId);
  @override
  Future<void> registerToEvent(int eventId) async => await datasource.registerToEvent(eventId);
  @override
  Future<List<EventRegistration>> getMyRegistrations() async => await datasource.getMyRegistrations();
  @override
  Future<void> unregisterFromEvent(int eventId) async => await datasource.unregisterFromEvent(eventId);

  // Nuevos Admin
  @override
  Future<void> createEvent(Map<String, dynamic> eventData) async {
    await datasource.createEvent(eventData);
  }

  @override
  Future<void> updateEvent(int eventId, Map<String, dynamic> eventData) async {
    await datasource.updateEvent(eventId, eventData);
  }

  @override
  Future<void> deleteEvent(int eventId) async {
    await datasource.deleteEvent(eventId);
  }

  @override
  Future<List<EventParticipant>> getEventParticipants(int eventId) async {
    return await datasource.getEventParticipants(eventId);
  }

  @override
  Future<List<EventParticipant>> getKitchenSubscribers(int kitchenId) async {
    return await datasource.getKitchenSubscribers(kitchenId);
  }
}