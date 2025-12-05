import 'package:bienestar_integral_app/core/router/routes.dart';
import 'package:bienestar_integral_app/features/admin_home/presentation/providers/admin_home_provider.dart';
import 'package:bienestar_integral_app/features/admin_home/presentation/widgets/admin_bottom_bar.dart';
import 'package:bienestar_integral_app/features/admin_home/presentation/widgets/admin_drawer.dart';
import 'package:bienestar_integral_app/features/admin_home/presentation/widgets/event_card_admin.dart';
import 'package:bienestar_integral_app/features/admin_home/presentation/widgets/kitchen_info_card.dart';
import 'package:bienestar_integral_app/features/settings/presentation/widgets/home_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {

  @override
  void initState() {
    super.initState();
    // Ejecutamos la carga al iniciar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminHomeProvider>().loadAdminKitchen();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AdminHomeProvider>();

    // Lógica de redirección automática si no hay horarios
    if (provider.status == AdminHomeStatus.success && provider.needsScheduleSetup) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Verificamos para no intentar navegar si ya estamos en esa ruta
        final targetPath = '${AppRoutes.kitchenSchedulePath}/${provider.kitchen?.id}';
        final currentPath = GoRouter.of(context).routerDelegate.currentConfiguration.fullPath;

        if (currentPath != targetPath) {
          context.go(targetPath);
        }
      });
    }

    return Scaffold(
      appBar: const HomeAppBar(title: 'Panel de Administrador'),
      drawer: const AdminDrawer(),
      body: _buildBody(provider),
      bottomNavigationBar: AdminBottomBar(
        onLaunchEvent: () => context.push(AppRoutes.launchEventPath),
        onManageUsers: () => context.push(AppRoutes.manageVolunteersPath),
        onAddProduct: () => context.push(AppRoutes.addProductPath),
      ),
    );
  }

  Widget _buildBody(AdminHomeProvider provider) {
    // 1. Estado de Carga
    if (provider.status == AdminHomeStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    // 2. Estado de Error
    if (provider.status == AdminHomeStatus.error) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'No se pudo cargar la información de la cocina.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                provider.errorMessage ?? 'Error desconocido',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => provider.loadAdminKitchen(),
                child: const Text('Reintentar'),
              )
            ],
          ),
        ),
      );
    }

    // 3. Estado de Éxito
    final kitchen = provider.kitchen;

    if (kitchen == null) {
      return const Center(child: Text("No se encontró información."));
    }

    // Preparar datos para la UI
    final Map<String, String> scheduleMap = {};
    for (var s in kitchen.schedules) {
      // Traducir días si es necesario, por ahora los mostramos tal cual vienen
      scheduleMap[s.day] = '${s.startTime} - ${s.endTime}';
    }

    final address = '${kitchen.location.streetAddress}, ${kitchen.location.neighborhood}';

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 8),

          KitchenInfoCard(
            title: kitchen.name,
            subtitle: address,
            ownerName: kitchen.ownerName, // Nombre del dueño real
            imageUrl: 'https://images.unsplash.com/photo-1556911220-e15b29be8c8f?w=800',
            schedule: scheduleMap.isEmpty
                ? {'Estado': 'Sin horarios'}
                : scheduleMap,
          ),

          const SizedBox(height: 8),

          // Eventos (Placeholder por ahora)
          const EventCardAdmin(
            eventNumber: '1',
            description: 'Evento de donación de alimentos...',
            date: '24/12/2025',
            currentCount: '0',
            maxCount: '20',
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}