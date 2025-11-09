import 'package:bienestar_integral_app/core/router/routes.dart';
import 'package:bienestar_integral_app/features/inventory/presentation/widgets/inventory_item_card.dart';
import 'package:bienestar_integral_app/features/settings/presentation/widgets/home_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: const HomeAppBar(title: 'Inventario', showBackButton: true),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: const [
                InventoryItemCard(name: 'Arroz', quantity: '25 kg', status: 'Disponible'),
                InventoryItemCard(name: 'Frijoles', quantity: '4 kg', status: 'Bajo stock'),
                InventoryItemCard(name: 'Leche', quantity: '8 L', status: 'Perecedero'),
                InventoryItemCard(name: 'Agua embotellada', quantity: '40 botellas', status: 'Disponible'),
              ],
            ),
          ),
          _buildBottomActionBar(context, colors),
        ],
      ),
    );
  }

  Widget _buildBottomActionBar(BuildContext context, ColorScheme colors) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.surface,
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => context.push(AppRoutes.registerPurchasePath),
                  child: const Text('Registrar Compra'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () { /* TODO: Navegar a registrar donación */ },
                  child: const Text('Registrar Donación'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => context.push(AppRoutes.addProductPath),
              child: const Text('Agregar Nuevo Producto'),
            ),
          ),
        ],
      ),
    );
  }
}