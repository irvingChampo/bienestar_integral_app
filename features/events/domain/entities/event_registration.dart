import 'package:bienestar_integral_app/features/events/domain/entities/event.dart';

class EventRegistration {
  final int id;
  final int eventId;
  final String registrationType;
  final Event? event; // Puede venir anidado según el endpoint

  EventRegistration({
    required this.id,
    required this.eventId,
    required this.registrationType,
    this.event,
  });
}