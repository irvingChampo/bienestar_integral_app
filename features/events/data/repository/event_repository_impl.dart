import 'package:bienestar_integral_app/features/events/data/datasource/event_datasource.dart';
import 'package:bienestar_integral_app/features/events/domain/entities/event.dart';
import 'package:bienestar_integral_app/features/events/domain/entities/event_registration.dart';
import 'package:bienestar_integral_app/features/events/domain/repository/event_repository.dart';

class EventRepositoryImpl implements EventRepository {
  final EventDatasource datasource;

  EventRepositoryImpl({required this.datasource});

  @override
  Future<List<Event>> getEventsByKitchen(int kitchenId) async {
    try {
      return await datasource.getEventsByKitchen(kitchenId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> registerToEvent(int eventId) async {
    try {
      await datasource.registerToEvent(eventId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<EventRegistration>> getMyRegistrations() async {
    try {
      return await datasource.getMyRegistrations();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> unregisterFromEvent(int eventId) async {
    try {
      await datasource.unregisterFromEvent(eventId);
    } catch (e) {
      rethrow;
    }
  }
}