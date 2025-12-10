import 'package:bienestar_integral_app/features/inventory/data/models/product_model.dart';
import 'package:bienestar_integral_app/features/inventory/domain/entities/inventory_item.dart';

class InventoryItemModel extends InventoryItem {
  InventoryItemModel({
    required super.inventoryId,
    required super.quantity,
    required super.product,
  });

  factory InventoryItemModel.fromJson(Map<String, dynamic> json) {
    // 1. Determinar dónde están los datos del producto
    Map<String, dynamic> productData;

    if (json['product'] != null && json['product'] is Map) {
      // CASO A: Estructura anidada (Documentación)
      // { "quantity": 10, "product": { "name": "Manzana"... } }
      productData = json['product'];
    } else {
      // CASO B: Estructura plana (Tu Postman Real)
      // { "productId": 4, "name": "Manzana", "quantity": 10 ... }

      // Creamos una copia para no alterar el original y mapeamos IDs si es necesario
      productData = Map<String, dynamic>.from(json);

      // Si viene 'productId', lo pasamos como 'id' para que ProductModel lo entienda
      if (json['productId'] != null) {
        productData['id'] = json['productId'];
      }
    }

    return InventoryItemModel(
      // A veces el ID del registro de inventario no viene en la estructura plana,
      // usamos 0 o el id del producto como fallback temporal para que no rompa.
      inventoryId: json['inventoryId'] ?? 0,
      quantity: (json['quantity'] as num?)?.toDouble() ?? 0.0,
      product: ProductModel.fromJson(productData),
    );
  }
}