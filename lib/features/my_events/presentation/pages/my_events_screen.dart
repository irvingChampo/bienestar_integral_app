import 'package:bienestar_integral_app/core/router/routes.dart';
import 'package:bienestar_integral_app/features/my_events/presentation/provider/my_events_provider.dart';
import 'package:bienestar_integral_app/features/my_events/presentation/widgets/empty_state_widget.dart';
import 'package:bienestar_integral_app/features/my_events/presentation/widgets/registration_card.dart'; // <-- 1. NUEVO IMPORT
import 'package:bienestar_integral_app/features/my_events/presentation/widgets/subscribed_kitchen_card.dart';
import 'package:bienestar_integral_app/features/settings/presentation/widgets/home_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class MyEventsScreen extends StatefulWidget {
  const MyEventsScreen({super.key});

  @override
  State<MyEventsScreen> createState() => _MyEventsScreenState();
}

class _MyEventsScreenState extends State<MyEventsScreen> {

  @override
  void initState() {
    super.initState();
    // Cargamos AMBAS listas al iniciar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<MyEventsProvider>();
      provider.fetchMySubscriptions(); // Pestaña 2
      provider.fetchMyRegistrations(); // Pestaña 1 (NUEVO)
    });
  }

  // --- LÓGICA PARA CANCELAR ASISTENCIA ---
  void _handleCancelRegistration(int eventId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancelar asistencia'),
        content: const Text('¿Estás seguro de que ya no podrás asistir a este evento?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Volver'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(context);

              final provider = context.read<MyEventsProvider>();
              final success = await provider.cancelEventRegistration(eventId);

              if (!mounted) return;

              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Asistencia cancelada.')),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(provider.errorMessage ?? 'Error al cancelar.'),
                    backgroundColor: Theme.of(context).colorScheme.error,
                  ),
                );
              }
            },
            child: const Text('Cancelar asistencia'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: HomeAppBar(
          title: 'Mi Actividad',
          showBackButton: true,
          bottom: TabBar(
            labelColor: colors.onPrimary,
            unselectedLabelColor: colors.onPrimary.withOpacity(0.6),
            indicatorColor: colors.onPrimary,
            indicatorWeight: 3,
            tabs: const [
              Tab(text: 'Mis Eventos'),
              Tab(text: 'Mis Cocinas'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildEventsTab(),
            _buildKitchensTab(),
          ],
        ),
      ),
    );
  }

  // --- PESTAÑA 1: EVENTOS (REAL DATA) ---
  Widget _buildEventsTab() {
    final provider = context.watch<MyEventsProvider>();

    if (provider.status == MyEventsStatus.loading && provider.registrations.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.registrations.isEmpty) {
      return const EmptyStateWidget(
        icon: Icons.event_available,
        title: 'No tienes eventos próximos',
        subtitle: 'Inscríbete a eventos en las cocinas para verlos aquí.',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: provider.registrations.length,
      itemBuilder: (context, index) {
        final registration = provider.registrations[index];
        return RegistrationCard(
          registration: registration,
          isLoading: provider.processingRegistrationId == registration.eventId,
          onCancel: () => _handleCancelRegistration(registration.eventId),
        );
      },
    );
  }

  // --- PESTAÑA 2: COCINAS (REAL DATA) ---
  Widget _buildKitchensTab() {
    final provider = context.watch<MyEventsProvider>();

    // Reutilizamos el status general, aunque idealmente se separarían los status
    // si las cargas fueran muy independientes. Para este caso simple, funciona.
    if (provider.status == MyEventsStatus.loading && provider.subscriptions.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.subscriptions.isEmpty) {
      return const EmptyStateWidget(
        icon: Icons.storefront,
        title: 'No sigues ninguna cocina',
        subtitle: 'Busca cocinas cercanas e inscríbete para ayudar.',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: provider.subscriptions.length,
      itemBuilder: (context, index) {
        final subscription = provider.subscriptions[index];
        return SubscribedKitchenCard(
          kitchen: subscription.kitchen,
          onTap: () {
            context.push(
              '${AppRoutes.eventDetailsPath}/${subscription.kitchen.id}',
              extra: subscription.kitchen.toDisplayData(),
            );
          },
        );
      },
    );
  }
}