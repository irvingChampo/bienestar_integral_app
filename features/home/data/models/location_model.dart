import 'package:bienestar_integral_app/features/home/domain/entities/location.dart';

class LocationModel extends Location {
  LocationModel({
    required super.id,
    required super.streetAddress,
    required super.neighborhood, // <-- CAMPO AÑADIDO
    required super.stateId,
    required super.municipalityId,
    required super.postalCode,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      id: json['id'] ?? 0,
      streetAddress: json['streetAddress'] ?? 'Dirección no disponible',
      neighborhood: json['neighborhood'] ?? 'Colonia no disponible', // <-- CAMPO AÑADIDO
      stateId: json['stateId'] ?? 0,
      municipalityId: json['municipalityId'] ?? 0,
      postalCode: json['postalCode'] ?? 'N/A',
    );
  }
}