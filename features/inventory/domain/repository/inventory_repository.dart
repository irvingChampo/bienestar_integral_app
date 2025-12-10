import 'package:bienestar_integral_app/features/inventory/domain/entities/category.dart';
import 'package:bienestar_integral_app/features/inventory/domain/entities/inventory_item.dart';
import 'package:bienestar_integral_app/features/inventory/domain/entities/product.dart';
import 'package:bienestar_integral_app/features/inventory/domain/entities/unit.dart'; // (+)

abstract class InventoryRepository {
  // Consultas
  Future<List<InventoryItem>> getKitchenInventory(int kitchenId);
  Future<Product> getProductById(int kitchenId, int productId);
  Future<List<Product>> getProductsByCategory(int kitchenId, int categoryId);

  // Auxiliares (Categorías y Unidades)
  Future<List<Category>> getCategories();
  Future<List<Unit>> getUnits(); // (+) NUEVO
  Future<void> createCategory({required String name, required String description});

  // Gestión de Productos
  Future<void> registerProduct({
    required int kitchenId,
    required String name,
    required String description,
    required int categoryId,
    required String unit,
    required bool perishable,
    int? shelfLifeDays,
  });

  Future<void> updateProduct({
    required int kitchenId,
    required int productId,
    required String name,
    required String description,
    required String unit,
  });

  Future<void> deleteProduct(int kitchenId, int productId);

  // Gestión de Stock
  Future<void> addStock(int kitchenId, int productId, double amount);
  Future<void> removeStock(int kitchenId, int productId, double amount);
  Future<void> setStock(int kitchenId, int productId, double quantity);
}