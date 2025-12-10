import 'package:bienestar_integral_app/features/inventory/domain/entities/inventory_item.dart';
import 'package:bienestar_integral_app/features/inventory/domain/repository/inventory_repository.dart';

class GetKitchenInventory {
  final InventoryRepository repository;
  GetKitchenInventory(this.repository);

  Future<List<InventoryItem>> call(int kitchenId) async {
    return await repository.getKitchenInventory(kitchenId);
  }
}