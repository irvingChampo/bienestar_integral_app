import 'package:bienestar_integral_app/core/router/routes.dart';
import 'package:bienestar_integral_app/features/auth/presentation/providers/auth_provider.dart';
// Importamos los widgets que acabamos de crear
import 'package:bienestar_integral_app/features/home/presentation/widgets/drawer_custom_header.dart';
import 'package:bienestar_integral_app/features/home/presentation/widgets/drawer_menu_item.dart';
import 'package:bienestar_integral_app/features/home/presentation/widgets/drawer_logout_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Drawer(
      backgroundColor: Colors.transparent, // Transparente para manejar bordes redondeados
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        child: Column(
          children: [
            // 1. Header (El archivo nuevo)
            const DrawerCustomHeader(),

            // 2. Lista de Opciones
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 10),
                children: [
                  DrawerMenuItem(
                    icon: Icons.home_filled,
                    text: 'Inicio',
                    onTap: () {
                      Navigator.pop(context);
                      // Si ya estás en home, solo cerramos el drawer
                    },
                  ),
                  DrawerMenuItem(
                    icon: Icons.edit,
                    text: 'Editar perfil',
                    onTap: () {
                      Navigator.pop(context);
                      context.push(AppRoutes.editProfilePath);
                    },
                  ),
                  DrawerMenuItem(
                    icon: Icons.event_note,
                    text: 'Mis eventos',
                    // NO pasamos badgeCount, así que no se mostrará nada
                    // badgeCount: 3, <--- Descomentar solo cuando tengas lógica real
                    onTap: () {
                      Navigator.pop(context);
                      context.push(AppRoutes.myEventsPath);
                    },
                  ),
                  DrawerMenuItem(
                    icon: Icons.settings,
                    text: 'Configuración',
                    onTap: () {
                      Navigator.pop(context);
                      context.push(AppRoutes.settingsPath);
                    },
                  ),

                  // Divisor visual
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    child: Divider(color: colorScheme.outline.withOpacity(0.2)),
                  ),

                  DrawerMenuItem(
                    icon: Icons.help_outline,
                    text: 'Ayuda y soporte',
                    onTap: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Próximamente')),
                      );
                    },
                  ),
                ],
              ),
            ),

            // 3. Botón Logout (El archivo nuevo)
            DrawerLogoutButton(
              onTap: () {
                Navigator.pop(context);
                context.read<AuthProvider>().logout();
              },
            ),
          ],
        ),
      ),
    );
  }
}