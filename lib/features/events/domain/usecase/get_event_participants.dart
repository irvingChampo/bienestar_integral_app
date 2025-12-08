import 'package:bienestar_integral_app/features/events/domain/entities/event_participant.dart';
import 'package:bienestar_integral_app/features/events/domain/repository/event_repository.dart';

class GetEventParticipants {
  final EventRepository repository;
  GetEventParticipants(this.repository);
  Future<List<EventParticipant>> call(int eventId) async => await repository.getEventParticipants(eventId);
}