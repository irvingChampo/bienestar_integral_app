import 'package:bienestar_integral_app/features/inventory/domain/repository/inventory_repository.dart';

class ManageProductStock {
  final InventoryRepository repository;
  ManageProductStock(this.repository);

  Future<void> add(int kitchenId, int productId, double amount) async {
    await repository.addStock(kitchenId, productId, amount);
  }

  Future<void> remove(int kitchenId, int productId, double amount) async {
    await repository.removeStock(kitchenId, productId, amount);
  }

  Future<void> set(int kitchenId, int productId, double quantity) async {
    await repository.setStock(kitchenId, productId, quantity);
  }
}