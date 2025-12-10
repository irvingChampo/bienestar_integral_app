import 'package:bienestar_integral_app/features/inventory/data/datasource/inventory_datasource.dart';
import 'package:bienestar_integral_app/features/inventory/domain/entities/category.dart';
import 'package:bienestar_integral_app/features/inventory/domain/entities/inventory_item.dart';
import 'package:bienestar_integral_app/features/inventory/domain/entities/product.dart';
import 'package:bienestar_integral_app/features/inventory/domain/entities/unit.dart';
import 'package:bienestar_integral_app/features/inventory/domain/repository/inventory_repository.dart';

class InventoryRepositoryImpl implements InventoryRepository {
  final InventoryDatasource datasource;

  InventoryRepositoryImpl({required this.datasource});

  @override
  Future<int> registerProduct({
    required int kitchenId,
    required String name,
    required String description,
    required int categoryId,
    required String unit,
    required bool perishable,
    int? shelfLifeDays,
    double initialQuantity = 0,
  }) async {
    // 1. Construir JSON conforme a tu todo.json
    final data = {
      "name": name,
      "description": description, // Se envía tal cual
      "categoryId": categoryId,
      "unit": unit,
      "perishable": perishable,
      "shelfLifeDays": perishable ? shelfLifeDays : null
    };

    // 2. Registrar y obtener ID
    final newProductId = await datasource.registerProduct(kitchenId, data);

    // 3. Si hay cantidad inicial, agregar stock inmediatamente
    if (initialQuantity > 0) {
      await datasource.addStock(kitchenId, newProductId, initialQuantity);
    }

    return newProductId;
  }

  // ... (Resto de métodos sin cambios) ...
  @override
  Future<List<Unit>> getUnits() async => await datasource.getUnits();

  @override
  Future<List<Category>> getCategories() async => await datasource.getCategories();

  @override
  Future<void> createCategory({required String name, required String description}) async =>
      await datasource.createCategory(name, description);

  @override
  Future<List<InventoryItem>> getKitchenInventory(int kitchenId) async =>
      await datasource.getKitchenInventory(kitchenId);

  @override
  Future<void> addStock(int kitchenId, int productId, double amount) async =>
      await datasource.addStock(kitchenId, productId, amount);

  @override
  Future<void> removeStock(int kitchenId, int productId, double amount) async =>
      await datasource.removeStock(kitchenId, productId, amount);

  @override
  Future<void> setStock(int kitchenId, int productId, double quantity) async =>
      await datasource.setStock(kitchenId, productId, quantity);

  @override
  Future<void> deleteProduct(int kitchenId, int productId) async =>
      await datasource.deleteProduct(kitchenId, productId);

  @override
  Future<Product> getProductById(int kitchenId, int productId) async =>
      await datasource.getProductById(kitchenId, productId);

  @override
  Future<List<Product>> getProductsByCategory(int kitchenId, int categoryId) async =>
      await datasource.getProductsByCategory(kitchenId, categoryId);

  @override
  Future<void> updateProduct({
    required int kitchenId,
    required int productId,
    required String name,
    required String description,
    required String unit,
  }) async {
    final data = {
      "name": name,
      "description": description,
      "unit": unit
    };
    await datasource.updateProduct(kitchenId, productId, data);
  }
}