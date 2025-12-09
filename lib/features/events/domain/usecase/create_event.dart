import 'package:bienestar_integral_app/features/events/domain/repository/event_repository.dart';

class CreateEvent {
  final EventRepository repository;
  CreateEvent(this.repository);
  Future<void> call(Map<String, dynamic> eventData) async => await repository.createEvent(eventData);
}