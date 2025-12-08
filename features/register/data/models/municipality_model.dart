import 'package:bienestar_integral_app/features/register/domain/entities/municipality.dart';

class MunicipalityModel extends Municipality {
  MunicipalityModel({
    required super.id,
    required super.name,
  });

  factory MunicipalityModel.fromJson(Map<String, dynamic> json) {
    return MunicipalityModel(
      id: json['id'],
      name: json['name'],
    );
  }
}