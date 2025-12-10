import 'package:bienestar_integral_app/core/router/routes.dart';
import 'package:bienestar_integral_app/features/admin_home/presentation/providers/admin_home_provider.dart';
import 'package:bienestar_integral_app/features/inventory/presentation/providers/inventory_provider.dart';
import 'package:bienestar_integral_app/features/inventory/presentation/widgets/inventory_item_card.dart';
import 'package:bienestar_integral_app/features/settings/presentation/widgets/home_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final kitchenId = context.read<AdminHomeProvider>().kitchen?.id;
      if (kitchenId != null) {
        context.read<InventoryProvider>().loadInventory(kitchenId);
      }
    });
  }

  void _showSetStockDialog(int productId, double currentQuantity) {
    final TextEditingController qtyCtrl = TextEditingController(text: currentQuantity.toString());
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Ajuste Manual de Inventario'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Ingresa la cantidad real física que tienes.'),
            const SizedBox(height: 16),
            TextField(
              controller: qtyCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Cantidad Total', border: OutlineInputBorder()),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              final newQty = double.tryParse(qtyCtrl.text);
              if (newQty != null && newQty >= 0) {
                final kitchenId = context.read<AdminHomeProvider>().kitchen?.id;
                if (kitchenId != null) {
                  context.read<InventoryProvider>().setStock(kitchenId: kitchenId, productId: productId, quantity: newQty);
                }
                Navigator.pop(ctx);
              }
            },
            child: const Text('Corregir'),
          )
        ],
      ),
    );
  }

  // (+) Método Actualizado con Descripción
  void _showEditProductDialog(int productId, String currentName, String currentDesc, String currentUnit) {
    final nameCtrl = TextEditingController(text: currentName);
    final descCtrl = TextEditingController(text: currentDesc); // (+)
    final unitCtrl = TextEditingController(text: currentUnit);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Editar Producto'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Nombre')),
            const SizedBox(height: 12),
            TextField(controller: descCtrl, decoration: const InputDecoration(labelText: 'Descripción')), // (+)
            const SizedBox(height: 12),
            TextField(controller: unitCtrl, decoration: const InputDecoration(labelText: 'Unidad')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              if (nameCtrl.text.isNotEmpty && unitCtrl.text.isNotEmpty) {
                final kitchenId = context.read<AdminHomeProvider>().kitchen?.id;
                if (kitchenId != null) {
                  context.read<InventoryProvider>().editProduct(
                      kitchenId: kitchenId,
                      productId: productId,
                      name: nameCtrl.text.trim(),
                      description: descCtrl.text.trim(), // (+)
                      unit: unitCtrl.text.trim()
                  );
                }
                Navigator.pop(ctx);
              }
            },
            child: const Text('Guardar'),
          )
        ],
      ),
    );
  }

  void _updateStockQuick(int productId, bool isAdding) {
    final kitchenId = context.read<AdminHomeProvider>().kitchen?.id;
    if (kitchenId != null) {
      context.read<InventoryProvider>().updateStock(
          kitchenId: kitchenId, productId: productId, amount: 1.0, isAdding: isAdding);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final inventoryProvider = context.watch<InventoryProvider>();
    final kitchenId = context.read<AdminHomeProvider>().kitchen?.id;

    return Scaffold(
      appBar: const HomeAppBar(title: 'Inventario', showBackButton: true),
      body: Column(
        children: [
          _buildFilterBar(inventoryProvider),

          Expanded(
            child: inventoryProvider.status == InventoryStatus.loading
                ? const Center(child: CircularProgressIndicator())
                : inventoryProvider.inventory.isEmpty
                ? const Center(child: Text('No hay productos.'))
                : RefreshIndicator(
              onRefresh: () async {
                if (kitchenId != null) await inventoryProvider.loadInventory(kitchenId);
              },
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: inventoryProvider.inventory.length,
                itemBuilder: (context, index) {
                  final item = inventoryProvider.inventory[index];
                  return InventoryItemCard(
                    item: item,
                    onAddStock: () => _updateStockQuick(item.product.id, true),
                    onRemoveStock: () => _updateStockQuick(item.product.id, false),
                    onSetStock: () => _showSetStockDialog(item.product.id, item.quantity),
                    // (+) Pasar descripción al editar
                    onEdit: () => _showEditProductDialog(
                        item.product.id,
                        item.product.name,
                        item.product.description,
                        item.product.unit
                    ),
                    onDelete: () async {
                      if (kitchenId != null) await inventoryProvider.deleteProduct(kitchenId, item.product.id);
                    },
                  );
                },
              ),
            ),
          ),
          _buildBottomActionBar(context, colors),
        ],
      ),
    );
  }

  Widget _buildFilterBar(InventoryProvider provider) {
    if (provider.categories.isEmpty) return const SizedBox.shrink();

    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: const Text('Todos'),
              selected: provider.currentFilter == null,
              onSelected: (_) => provider.setCategoryFilter(null),
            ),
          ),
          ...provider.categories.map((cat) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(cat.name),
                selected: provider.currentFilter == cat.id,
                onSelected: (selected) {
                  provider.setCategoryFilter(selected ? cat.id : null);
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildBottomActionBar(BuildContext context, ColorScheme colors) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.surface,
        boxShadow: [BoxShadow(color: colors.shadow.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -2))],
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () => context.push(AppRoutes.addProductPath),
          child: const Text('Registrar Nuevo Producto'),
        ),
      ),
    );
  }
}