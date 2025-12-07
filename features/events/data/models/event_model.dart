import 'package:bienestar_integral_app/features/events/domain/entities/event.dart';

class EventModel extends Event {
  EventModel({
    required super.id,
    required super.kitchenId,
    required super.name,
    required super.description,
    required super.eventDate,
    required super.startTime,
    required super.endTime,
    required super.maxCapacity,
    super.eventType,
    super.expectedDiners,
    super.status,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'] ?? 0,
      kitchenId: json['kitchenId'] ?? 0,
      name: json['name'] ?? 'Evento sin nombre',
      description: json['description'] ?? '',
      eventDate: json['eventDate'] ?? '',
      startTime: json['startTime'] ?? '',
      endTime: json['endTime'] ?? '',
      maxCapacity: json['maxCapacity'] ?? 0,
      eventType: json['eventType'],
      expectedDiners: json['expectedDiners'],
      status: json['status'],
    );
  }
}