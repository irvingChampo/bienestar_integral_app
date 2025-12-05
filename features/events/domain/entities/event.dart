class Event {
  final int id;
  final int kitchenId;
  final String name;
  final String description;
  final String eventDate; // Formato YYYY-MM-DD
  final String startTime; // Formato HH:mm
  final String endTime;   // Formato HH:mm
  final int maxCapacity;

  // Nuevos campos para Admin (pueden ser nulos si vienen de una vista simple)
  final String? eventType;
  final int? expectedDiners;
  final String? status;

  Event({
    required this.id,
    required this.kitchenId,
    required this.name,
    required this.description,
    required this.eventDate,
    required this.startTime,
    required this.endTime,
    required this.maxCapacity,
    this.eventType,
    this.expectedDiners,
    this.status,
  });
}