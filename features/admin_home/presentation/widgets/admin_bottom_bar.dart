import 'package:flutter/material.dart';

class AdminBottomBar extends StatelessWidget {
  final VoidCallback onLaunchEvent;
  // Se eliminó onManageUsers
  final VoidCallback onAddProduct;

  const AdminBottomBar({
    super.key,
    required this.onLaunchEvent,
    // Se eliminó required this.onManageUsers
    required this.onAddProduct,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: colors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _AdminBottomBarItem(
            icon: Icons.newspaper,
            label: 'Lanzar\nevento',
            onTap: onLaunchEvent,
          ),
          // --- AQUÍ SE ELIMINÓ EL ÍTEM DE GESTIONAR USUARIOS ---
          _AdminBottomBarItem(
            icon: Icons.note_add,
            label: 'Ingresar\nproducto',
            onTap: onAddProduct,
          ),
        ],
      ),
    );
  }
}

class _AdminBottomBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _AdminBottomBarItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 28),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: textTheme.labelSmall?.copyWith(height: 1.2),
            ),
          ],
        ),
      ),
    );
  }
}