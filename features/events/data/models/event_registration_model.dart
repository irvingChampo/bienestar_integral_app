import 'package:bienestar_integral_app/features/events/data/models/event_model.dart';
import 'package:bienestar_integral_app/features/events/domain/entities/event_registration.dart';

class EventRegistrationModel extends EventRegistration {
  EventRegistrationModel({
    required super.id,
    required super.eventId,
    required super.registrationType,
    super.event,
  });

  factory EventRegistrationModel.fromJson(Map<String, dynamic> json) {
    return EventRegistrationModel(
      id: json['id'] ?? 0,
      eventId: json['eventId'] ?? 0,
      registrationType: json['registrationType'] ?? 'volunteer',
      // Si viene el objeto 'event' completo (como en my-registrations), lo parseamos
      event: json['event'] != null ? EventModel.fromJson(json['event']) : null,
    );
  }
}