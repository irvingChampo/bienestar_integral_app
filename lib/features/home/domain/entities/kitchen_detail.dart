import 'package:bienestar_integral_app/features/home/domain/entities/location.dart';

class Schedule {
  final String day;
  final String startTime;
  final String endTime;

  Schedule({required this.day, required this.startTime, required this.endTime});
}

class KitchenDetail {
  final int id;
  final String name;
  final String description;
  final bool isActive;
  final String? contactPhone;
  final String? contactEmail;
  final Location location;
  final bool isSubscribed;
  final List<Schedule> schedules;
  final String ownerName; // <-- NUEVO CAMPO

  KitchenDetail({
    required this.id,
    required this.name,
    required this.description,
    required this.isActive,
    this.contactPhone,
    this.contactEmail,
    required this.location,
    this.isSubscribed = false,
    required this.schedules,
    required this.ownerName, // <-- NUEVO
  });
}