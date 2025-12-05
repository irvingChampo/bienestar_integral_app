import 'package:bienestar_integral_app/features/events/domain/repository/event_repository.dart';

class UnregisterFromEvent {
  final EventRepository repository;
  UnregisterFromEvent(this.repository);
  Future<void> call(int eventId) async => await repository.unregisterFromEvent(eventId);
}