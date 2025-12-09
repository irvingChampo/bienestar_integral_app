import 'package:bienestar_integral_app/features/events/domain/entities/event_registration.dart';
import 'package:bienestar_integral_app/features/events/domain/repository/event_repository.dart';

class GetMyEventRegistrations {
  final EventRepository repository;
  GetMyEventRegistrations(this.repository);
  Future<List<EventRegistration>> call() async => await repository.getMyRegistrations();
}