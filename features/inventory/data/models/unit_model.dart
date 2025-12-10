import 'package:bienestar_integral_app/features/inventory/domain/entities/unit.dart';

class UnitModel extends Unit {
  UnitModel({required super.key, required super.label});

  factory UnitModel.fromJson(Map<String, dynamic> json) {
    return UnitModel(
      key: json['key'] ?? '',
      label: json['label'] ?? '',
    );
  }
}