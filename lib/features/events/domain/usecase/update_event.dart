import 'package:bienestar_integral_app/features/events/domain/repository/event_repository.dart';

class UpdateEvent {
  final EventRepository repository;
  UpdateEvent(this.repository);
  Future<void> call(int eventId, Map<String, dynamic> eventData) async => await repository.updateEvent(eventId, eventData);
}