import 'package:bienestar_integral_app/core/router/routes.dart';
import 'package:bienestar_integral_app/features/events/presentation/widgets/success_dialog.dart';
import 'package:bienestar_integral_app/features/my_events/presentation/provider/my_events_provider.dart';
import 'package:bienestar_integral_app/features/my_events/presentation/widgets/empty_state_widget.dart';
import 'package:bienestar_integral_app/features/my_events/presentation/widgets/my_event_card.dart';
import 'package:bienestar_integral_app/features/my_events/presentation/widgets/subscribed_kitchen_card.dart'; // <-- NUEVO IMPORT
import 'package:bienestar_integral_app/features/profile/presentation/widgets/confirmation_dialog.dart';
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
  // Datos de ejemplo para la pestaña de Eventos (Tareas)
  final List<Map<String, dynamic>> _myEvents = [
    {
      'eventName': 'Cena navideña', 'date': '03 Oct 2026', 'time': '02:30 pm - 5:00 pm',
      'location': 'Calzada al sumidero, enfrente de Bodega Aurrera',
      'tasks': ['Personal de limpieza', 'Personal de apoyo'],
    },
    {
      'eventName': 'Desayuno Comunitario', 'date': '10 Nov 2026', 'time': '08:00 am - 11:00 am',
      'location': 'Parque central, quiosco principal',
      'tasks': ['Servicio de alimentos'],
    },
  ];

  @override
  void initState() {
    super.initState();
    // Cargamos las suscripciones reales al iniciar la pantalla
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MyEventsProvider>().fetchMySubscriptions();
    });
  }

  void _handleMarkComplete(String eventName) {
    showDialog(
      context: context,
      builder: (_) => ConfirmationDialog(
        title: 'Marcar como completada',
        message: '¿Deseas marcar tu participación en este evento como completada?',
        onConfirm: () {
          showDialog(
            context: context,
            builder: (_) => const SuccessDialog(message: '¡Tarea marcada como completada!'),
          );
        },
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
            labelColor: colors.onPrimary, // Color del texto seleccionado (sobre el fondo amarillo)
            unselectedLabelColor: colors.onPrimary.withOpacity(0.6), // Texto no seleccionado
            indicatorColor: colors.onPrimary, // Línea indicadora
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

  // --- PESTAÑA 1: EVENTOS (DUMMY DATA) ---
  Widget _buildEventsTab() {
    if (_myEvents.isEmpty) {
      return const EmptyStateWidget(
        icon: Icons.event_busy,
        title: 'No tienes eventos asignados',
        subtitle: 'Cuando te asignen tareas específicas, aparecerán aquí.',
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: _myEvents.length,
      itemBuilder: (context, index) {
        final event = _myEvents[index];
        return MyEventCard(
          eventName: event['eventName'],
          date: event['date'],
          time: event['time'],
          location: event['location'],
          tasks: List<String>.from(event['tasks']),
          onMarkComplete: () => _handleMarkComplete(event['eventName']),
        );
      },
    );
  }

  // --- PESTAÑA 2: COCINAS (REAL DATA) ---
  Widget _buildKitchensTab() {
    final provider = context.watch<MyEventsProvider>();

    switch (provider.status) {
      case MyEventsStatus.loading:
        return const Center(child: CircularProgressIndicator());

      case MyEventsStatus.error:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                provider.errorMessage ?? 'Error al cargar suscripciones',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.read<MyEventsProvider>().fetchMySubscriptions(),
                child: const Text('Reintentar'),
              ),
            ],
          ),
        );

      case MyEventsStatus.initial:
      case MyEventsStatus.success:
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
                // Navegar a los detalles de la cocina usando su ID real
                context.push(
                  '${AppRoutes.eventDetailsPath}/${subscription.kitchen.id}',
                  // Pasamos datos básicos para que la carga visual sea inmediata
                  extra: subscription.kitchen.toDisplayData(),
                );
              },
            );
          },
        );
    }
  }
}