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
          // Header
          DrawerHeader(
            decoration: BoxDecoration(color: colors.primary),
            child: Center(
              child: Text(
                'Panel de Admin',
                style: textTheme.headlineSmall?.copyWith(color: colors.onPrimary),
              ),
            ),
          ),

          // Opciones del menú
          _buildDrawerItem(
            context,
            icon: Icons.inventory_2_outlined,
            title: 'Inventario',
            routeName: AppRoutes.inventoryPath,
          ),
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
          _buildDrawerItem(
            context,
            icon: Icons.settings_outlined,
            title: 'Configuración',
            routeName: AppRoutes.settingsPath,
          ),

          const Spacer(),

          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: colors.outline.withOpacity(0.1)),
              ),
            ),
            child: Material(
              color: colors.error, // Rojo base
              borderRadius: BorderRadius.circular(16),
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                  context.read<AppState>().logout();
                },
                borderRadius: BorderRadius.circular(16),

                // --- CONFIGURACIÓN DE COLORES DE INTERACCIÓN ---
                hoverColor: Colors.red.shade900, // Se oscurece al pasar el cursor
                splashColor: Colors.white.withOpacity(0.2),
                highlightColor: Colors.white.withOpacity(0.1),

                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.logout, color: Colors.white, size: 20),
                      SizedBox(width: 12),
                      Text(
                        'Cerrar sesión',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // -----------------------------------------------------------

          SizedBox(height: MediaQuery.of(context).padding.bottom),
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