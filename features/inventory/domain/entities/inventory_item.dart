import 'package:bienestar_integral_app/features/inventory/domain/entities/product.dart';

class InventoryItem {
  final int inventoryId;
  final double quantity;
  final Product product;

  InventoryItem({
    required this.inventoryId,
    required this.quantity,
    required this.product,
  });
}