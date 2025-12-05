import 'package:bienestar_integral_app/features/home/domain/entities/location.dart';

class KitchenDetail {
  final int id;
  final String name;
  final String description;
  final bool isActive;
  final String? contactPhone;
  final String? contactEmail;
  final Location location;
  final bool isSubscribed; // <-- NUEVO CAMPO

  KitchenDetail({
    required this.id,
    required this.name,
    required this.description,
    required this.isActive,
    this.contactPhone,
    this.contactEmail,
    required this.location,
    this.isSubscribed = false, // <-- Valor por defecto
  });
}