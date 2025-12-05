class Event {
  final int id;
  final int kitchenId; // <-- NUEVO
  final String name;
  final String description;
  final String eventDate;
  final String startTime;
  final String endTime; // <-- NUEVO
  final int maxCapacity;

  Event({
    required this.id,
    required this.kitchenId,
    required this.name,
    required this.description,
    required this.eventDate,
    required this.startTime,
    required this.endTime,
    required this.maxCapacity,
  });
}