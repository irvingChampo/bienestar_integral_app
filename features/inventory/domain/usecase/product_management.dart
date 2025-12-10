import 'package:bienestar_integral_app/features/inventory/domain/repository/inventory_repository.dart';

class ProductManagement {
  final InventoryRepository repository;
  ProductManagement(this.repository);

  Future<void> register({
    required int kitchenId,
    required String name,
    required String description, // (+)
    required int categoryId,
    required String unit,
    required bool perishable,
    int? shelfLifeDays, // (+)
  }) async {
    await repository.registerProduct(
      kitchenId: kitchenId,
      name: name,
      description: description,
      categoryId: categoryId,
      unit: unit,
      perishable: perishable,
      shelfLifeDays: shelfLifeDays,
    );
  }

  Future<void> delete(int kitchenId, int productId) async {
    await repository.deleteProduct(kitchenId, productId);
  }
}