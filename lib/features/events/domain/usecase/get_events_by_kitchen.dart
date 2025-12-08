import 'package:bienestar_integral_app/features/events/domain/entities/event.dart';
import 'package:bienestar_integral_app/features/events/domain/repository/event_repository.dart';

class GetEventsByKitchen {
  final EventRepository repository;
  GetEventsByKitchen(this.repository);
  Future<List<Event>> call(int kitchenId) async => await repository.getEventsByKitchen(kitchenId);
}