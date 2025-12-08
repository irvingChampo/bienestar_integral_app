import 'package:bienestar_integral_app/features/events/domain/repository/event_repository.dart';

class RegisterToEvent {
  final EventRepository repository;
  RegisterToEvent(this.repository);
  Future<void> call(int eventId) async => await repository.registerToEvent(eventId);
}