import 'package:bienestar_integral_app/core/application/app_state.dart';
import 'package:bienestar_integral_app/core/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AdminDrawer extends StatelessWidget {
  const AdminDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: colors.primary),
            child: Center(
              child: Text(
                'Panel de Admin',
                style: textTheme.headlineSmall?.copyWith(color: colors.onPrimary),
              ),
            ),
          ),
          _buildDrawerItem(
            context,
            icon: Icons.inventory_2_outlined,
            title: 'Inventario',
            routeName: AppRoutes.inventoryPath,
          ),
          // --- NUEVOS ITEMS DEL MENÚ ---
          _buildDrawerItem(
            context,
            icon: Icons.receipt_long_outlined,
            title: 'Estado de Cuenta',
            routeName: AppRoutes.accountStatusPath,
          ),
          _buildDrawerItem(
            context,
            icon: Icons.support_agent,
            title: 'Chef IA',
            routeName: AppRoutes.chefIaPath,
          ),
          // --- FIN DE NUEVOS ITEMS ---
          _buildDrawerItem(
            context,
            icon: Icons.settings_outlined,
            title: 'Configuración',
            routeName: AppRoutes.settingsPath,
          ),
          const Spacer(),
          const Divider(height: 1),
          ListTile(
            leading: Icon(Icons.logout, color: colors.error),
            title: Text(
              'Cerrar sesión',
              style: textTheme.bodyLarge?.copyWith(color: colors.error),
            ),
            onTap: () {
              Navigator.pop(context);
              context.read<AppState>().logout();
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context, {required IconData icon, required String title, required String routeName}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title, style: Theme.of(context).textTheme.bodyLarge),
      onTap: () {
        Navigator.pop(context);
        context.push(routeName);
      },
    );
  }
}