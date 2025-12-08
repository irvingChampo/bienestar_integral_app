import 'package:bienestar_integral_app/features/events/domain/repository/event_repository.dart';

class DeleteEvent {
  final EventRepository repository;
  DeleteEvent(this.repository);
  Future<void> call(int eventId) async => await repository.deleteEvent(eventId);
}