import 'package:bienestar_integral_app/core/application/app_state.dart';
import 'package:bienestar_integral_app/core/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            // Encabezado del Drawer
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              color: colorScheme.primary,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundColor: colorScheme.onPrimary,
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Bienestar Integral', // Nombre de usuario
                    style: textTheme.titleMedium?.copyWith(
                      color: colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Opciones de navegación
            ListTile(
              leading: Icon(Icons.edit, color: colorScheme.primary),
              title: Text('Editar perfil', style: textTheme.bodyLarge),
              onTap: () {
                Navigator.pop(context); // Cierra el drawer
                context.push(AppRoutes.editProfilePath);
              },
            ),
            const Divider(height: 1, indent: 16, endIndent: 16),
            ListTile(
              leading: Icon(Icons.event_note, color: colorScheme.primary),
              title: Text('Mis eventos', style: textTheme.bodyLarge),
              onTap: () {
                Navigator.pop(context);
                context.push(AppRoutes.myEventsPath);
              },
            ),
            const Divider(height: 1, indent: 16, endIndent: 16),
            ListTile(
              leading: Icon(Icons.settings, color: colorScheme.primary),
              title: Text('Configuración', style: textTheme.bodyLarge),
              onTap: () {
                Navigator.pop(context);
                context.push(AppRoutes.settingsPath);
              },
            ),

            const Spacer(), // Empuja el logout al final

            // Opción de Cerrar Sesión
            ListTile(
              leading: Icon(Icons.logout, color: colorScheme.error),
              title: Text('Cerrar sesión', style: textTheme.bodyLarge?.copyWith(color: colorScheme.error)),
              onTap: () {
                Navigator.pop(context);
                // Aquí podrías mostrar un diálogo de confirmación antes de cerrar sesión
                context.read<AppState>().logout();
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}