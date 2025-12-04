// features/home/domain/entities/kitchen_detail.dart (MODIFICADO)

import 'package:bienestar_integral_app/features/home/domain/entities/location.dart';

class KitchenDetail {
  final int id;
  final String name;
  final String description;
  final bool isActive;
  final String? contactPhone; // <-- CAMPO AÑADIDO (es opcional en JSON)
  final String? contactEmail; // <-- CAMPO AÑADIDO (es opcional en JSON)
  final Location location;

  KitchenDetail({
    required this.id,
    required this.name,
    required this.description,
    required this.isActive,
    this.contactPhone, // <-- CAMPO AÑADIDO
    this.contactEmail, // <-- CAMPO AÑADIDO
    required this.location,
  });
}