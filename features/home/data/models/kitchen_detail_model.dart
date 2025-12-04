// features/home/data/models/kitchen_detail_model.dart (MODIFICADO)

import 'package:bienestar_integral_app/features/home/data/models/location_model.dart';
import 'package:bienestar_integral_app/features/home/domain/entities/kitchen_detail.dart';

class KitchenDetailModel extends KitchenDetail {
  KitchenDetailModel({
    required super.id,
    required super.name,
    required super.description,
    required super.isActive,
    super.contactPhone, // Añadido
    super.contactEmail, // Añadido
    required super.location,
  });

  factory KitchenDetailModel.fromJson(Map<String, dynamic> json) {
    final kitchenData = json['kitchen'] is Map<String, dynamic>
        ? json['kitchen']
        : <String, dynamic>{};

    final locationData = kitchenData['location'] is Map<String, dynamic>
        ? kitchenData['location']
        : <String, dynamic>{};

    return KitchenDetailModel(
      id: kitchenData['id'] ?? 0,
      name: kitchenData['name'] ?? 'Nombre no disponible',
      description: kitchenData['description'] ?? 'Sin descripción disponible.',
      isActive: kitchenData['isActive'] ?? false,
      contactPhone: kitchenData['contactPhone'], // Se lee el campo directamente
      contactEmail: kitchenData['contactEmail'], // Se lee el campo directamente
      location: LocationModel.fromJson(locationData),
    );
  }
}