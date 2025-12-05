import 'package:bienestar_integral_app/core/router/routes.dart';
import 'package:bienestar_integral_app/features/admin_home/presentation/providers/admin_events_provider.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminHomeProvider>().loadAdminKitchen().then((_) {
        final kitchenId = context.read<AdminHomeProvider>().kitchen?.id;
        if (kitchenId != null) {
          context.read<AdminEventsProvider>().loadKitchenEvents(kitchenId);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final homeProvider = context.watch<AdminHomeProvider>();
    final eventsProvider = context.watch<AdminEventsProvider>();

    if (homeProvider.status == AdminHomeStatus.success && homeProvider.needsScheduleSetup) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final targetPath = '${AppRoutes.kitchenSchedulePath}/${homeProvider.kitchen?.id}';
        final currentPath = GoRouter.of(context).routerDelegate.currentConfiguration.fullPath;
        if (currentPath != targetPath) context.go(targetPath);
      });
    }

    return Scaffold(
      appBar: const HomeAppBar(title: 'Panel de Administrador'),
      drawer: const AdminDrawer(),
      body: _buildBody(homeProvider, eventsProvider),
      bottomNavigationBar: AdminBottomBar(
        onLaunchEvent: () => context.push(AppRoutes.launchEventPath),
        onManageUsers: () {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Selecciona un evento de la lista para ver sus voluntarios')));
        },
        onAddProduct: () => context.push(AppRoutes.addProductPath),
      ),
    );
  }

  Widget _buildBody(AdminHomeProvider homeProvider, AdminEventsProvider eventsProvider) {
    if (homeProvider.status == AdminHomeStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    final kitchen = homeProvider.kitchen;
    if (kitchen == null) return const Center(child: Text("No se encontró información."));

    final scheduleMap = <String, String>{};
    for (var s in kitchen.schedules) {
      scheduleMap[s.day] = '${s.startTime} - ${s.endTime}';
    }

    return RefreshIndicator(
      onRefresh: () async {
        await homeProvider.loadAdminKitchen();
        if (kitchen.id != 0) await eventsProvider.loadKitchenEvents(kitchen.id);
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 8),
            KitchenInfoCard(
              title: kitchen.name,
              subtitle: '${kitchen.location.streetAddress}, ${kitchen.location.neighborhood}',
              ownerName: kitchen.ownerName,
              imageUrl: 'https://images.unsplash.com/photo-1556911220-e15b29be8c8f?w=800',
              schedule: scheduleMap.isEmpty ? {'Estado': 'Sin horarios'} : scheduleMap,
            ),

            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Mis Eventos Activos', style: Theme.of(context).textTheme.titleLarge),
              ),
            ),
            const SizedBox(height: 8),

            if (eventsProvider.status == AdminEventStatus.loading)
              const Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator())
            else if (eventsProvider.events.isEmpty)
              const Padding(
                padding: EdgeInsets.all(32.0),
                child: Text('No has creado eventos aún.'),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: eventsProvider.events.length,
                itemBuilder: (context, index) {
                  final event = eventsProvider.events[index];
                  return GestureDetector(
                    onTap: () {
                      context.push(AppRoutes.manageVolunteersPath, extra: event);
                    },
                    // --- AQUÍ ESTÁ EL CAMBIO PRINCIPAL ---
                    child: EventCardAdmin(
                      title: event.name, // Pasamos el nombre real
                      description: event.description,
                      date: '${event.eventDate} (${event.startTime})',
                      currentCount: '?',
                      maxCount: event.maxCapacity.toString(),
                    ),
                  );
                },
              ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}