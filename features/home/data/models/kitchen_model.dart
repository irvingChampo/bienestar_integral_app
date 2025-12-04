// features/home/data/models/kitchen_model.dart (CORREGIDO Y MÁS ROBUSTO)

import 'package:bienestar_integral_app/features/home/domain/entities/kitchen.dart';

const _sampleImageUrls = [
  'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?w=800',
  'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=800',
  'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=800',
  'https://images.unsplash.com/photo-1490645935967-10de6ba17061?w=800',
];

class KitchenModel extends Kitchen {
  KitchenModel({
    required super.id,
    required super.name,
    required super.description,
    required super.stateId,
    required super.municipalityId,
    required super.imageUrl,
  });

  factory KitchenModel.fromJson(Map<String, dynamic> json) {
    final imageUrl = _sampleImageUrls[json['id'] % _sampleImageUrls.length];

    // --- INICIO DE LA CORRECCIÓN ---
    // Hacemos el parseo de la ubicación de forma segura, proveyendo valores por defecto si no existe.
    int stateId = 0;
    int municipalityId = 0;

    if (json['location'] != null && json['location'] is Map) {
      stateId = json['location']['state_id'] ?? 0;
      municipalityId = json['location']['municipality_id'] ?? 0;
    }
    // --- FIN DE LA CORRECCIÓN ---

    return KitchenModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Nombre no disponible',
      description: json['description'] ?? 'Sin descripción',
      stateId: stateId,
      municipalityId: municipalityId,
      imageUrl: imageUrl,
    );
  }
}