import 'package:bienestar_integral_app/features/inventory/domain/entities/category.dart';
import 'package:bienestar_integral_app/features/inventory/domain/repository/inventory_repository.dart';

class GetCategories {
  final InventoryRepository repository;
  GetCategories(this.repository);

  Future<List<Category>> call() async {
    return await repository.getCategories();
  }
}