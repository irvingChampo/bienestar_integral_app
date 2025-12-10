import 'package:bienestar_integral_app/features/inventory/domain/repository/inventory_repository.dart';

class CreateCategory {
  final InventoryRepository repository;
  CreateCategory(this.repository);

  Future<void> call({required String name, required String description}) async {
    await repository.createCategory(name: name, description: description);
  }
}