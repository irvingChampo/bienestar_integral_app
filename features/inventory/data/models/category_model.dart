import 'package:bienestar_integral_app/features/inventory/domain/entities/category.dart';

class CategoryModel extends Category {
  CategoryModel({
    required super.id,
    required super.name,
    required super.description,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Sin nombre',
      description: json['description'] ?? '',
    );
  }
}