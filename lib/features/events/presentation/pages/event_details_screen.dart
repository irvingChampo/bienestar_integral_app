import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:bienestar_integral_app/features/events/domain/entities/event.dart';
import 'package:bienestar_integral_app/features/events/presentation/providers/event_details_provider.dart';
import 'package:bienestar_integral_app/features/events/presentation/providers/events_provider.dart'; // <-- 1. NUEVO IMPORT
import 'package:bienestar_integral_app/features/events/presentation/widgets/event_info_row.dart';
import 'package:bienestar_integral_app/features/events/presentation/widgets/event_list_card.dart'; // <-- 2. NUEVO IMPORT
import 'package:bienestar_integral_app/features/home/domain/entities/kitchen_detail.dart';
import 'package:bienestar_integral_app/features/payments/presentation/widgets/donation_dialog.dart';
import 'package:bienestar_integral_app/features/settings/presentation/widgets/home_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventDetailsScreen extends StatefulWidget {
  final int kitchenId;
  final Map<String, String>? initialData;

  const EventDetailsScreen({
    super.key,
    required this.kitchenId,
    this.initialData,
  });

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Cargar detalles de la cocina (Existente)
      context.read<EventDetailsProvider>().fetchKitchenDetails(widget.kitchenId);
      // Cargar eventos de la cocina (NUEVO)
      context.read<EventsProvider>().fetchEventsByKitchen(widget.kitchenId);
    });
  }

  // --- LÓGICA PARA UNIRSE A UN EVENTO ---
  void _handleJoinEvent(Event event) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar asistencia'),
        content: Text('¿Deseas inscribirte al evento "${event.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);

              final eventsProvider = context.read<EventsProvider>();
              final success = await eventsProvider.joinEvent(event.id);

              if (!mounted) return;

              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('¡Te has inscrito al evento correctamente!'),
                    backgroundColor: Colors.green,
                  ),
                );
                // Opcional: Recargar mis inscripciones si fuera necesario
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(eventsProvider.errorMessage ?? 'Error al inscribirse.'),
                    backgroundColor: Theme.of(context).colorScheme.error,
                  ),
                );
              }
            },
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final detailsProvider = context.watch<EventDetailsProvider>();
    // Observamos también el EventsProvider para la lista de eventos
    final eventsProvider = context.watch<EventsProvider>();

    return Scaffold(
      appBar: const HomeAppBar(title: 'Detalles de la Cocina', showBackButton: true),
      body: _buildBody(detailsProvider, eventsProvider),
      bottomNavigationBar: _buildBottomActionBar(context, detailsProvider),
    );
  }

  Widget _buildBody(EventDetailsProvider detailsProvider, EventsProvider eventsProvider) {
    // Si los detalles de la cocina cargan o fallan, se maneja aquí.
    // La lista de eventos se maneja dentro de _buildContent para que sea parte del scroll.

    switch (detailsProvider.status) {
      case EventDetailsStatus.loading:
        return _buildContent(null, eventsProvider, isLoading: true);
      case EventDetailsStatus.error:
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text(
              detailsProvider.errorMessage ?? 'Error al cargar los detalles',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        );
      case EventDetailsStatus.initial:
      case EventDetailsStatus.success:
        if (detailsProvider.kitchenDetail == null) {
          return const Center(child: Text('No se encontraron detalles de la cocina.'));
        }
        return _buildContent(detailsProvider.kitchenDetail!, eventsProvider);
    }
  }

  Widget _buildContent(KitchenDetail? kitchenDetail, EventsProvider eventsProvider, {bool isLoading = false}) {
    final theme = Theme.of(context);

    final name = kitchenDetail?.name ?? widget.initialData?['title'] ?? 'Cargando...';
    final description = kitchenDetail?.description ?? widget.initialData?['description'] ?? '...';
    final imageUrl = widget.initialData?['image'] ?? 'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?w=800';
    final streetAddress = kitchenDetail?.location.streetAddress ?? 'Dirección no disponible';
    final neighborhood = kitchenDetail?.location.neighborhood ?? 'Colonia no disponible';
    final contactPhone = kitchenDetail?.contactPhone ?? 'No disponible';
    final contactEmail = kitchenDetail?.contactEmail ?? 'No disponible';
    const String schedule = 'Lunes a Viernes, 9:00 AM - 5:00 PM';

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildImageHeader(context, name, imageUrl),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Descripción', style: theme.textTheme.titleLarge),
                const SizedBox(height: 8),
                Text(description, style: theme.textTheme.bodyLarge?.copyWith(height: 1.5)),
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 16),
                EventInfoRow(icon: Icons.location_on, label: 'Dirección', value: streetAddress),
                const SizedBox(height: 12),
                EventInfoRow(icon: Icons.location_city, label: 'Colonia', value: neighborhood),
                const SizedBox(height: 12),
                EventInfoRow(icon: Icons.phone, label: 'Teléfono de Contacto', value: contactPhone),
                const SizedBox(height: 12),
                EventInfoRow(icon: Icons.email, label: 'Correo de Contacto', value: contactEmail),
                const SizedBox(height: 12),
                EventInfoRow(icon: Icons.schedule, label: 'Horarios de Operación', value: schedule),

                const SizedBox(height: 32),

                // --- SECCIÓN DE EVENTOS (NUEVA) ---
                Text('Próximos Eventos', style: theme.textTheme.headlineSmall),
                const SizedBox(height: 16),

                if (eventsProvider.status == EventsStatus.loading)
                  const Center(child: CircularProgressIndicator())
                else if (eventsProvider.status == EventsStatus.error)
                  Center(child: Text(eventsProvider.errorMessage ?? 'Error al cargar eventos'))
                else if (eventsProvider.events.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text('No hay eventos programados próximamente.'),
                      ),
                    )
                  else
                    ...eventsProvider.events.map((event) => EventListCard(
                      event: event,
                      // Mostramos carga solo en la tarjeta que se está procesando
                      isLoading: eventsProvider.processingEventId == event.id,
                      onJoin: () => _handleJoinEvent(event),
                    )),
              ],
            ),
          ),
          if (isLoading) const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator())),
        ],
      ),
    );
  }

  // ... (El resto de métodos: _buildImageHeader, _buildBottomActionBar, _handleDonate, etc. SE MANTIENEN IGUAL) ...
  // COPIA AQUÍ LOS MÉTODOS EXISTENTES DEL PASO ANTERIOR (Suscripción/Donación) PARA COMPLETAR LA CLASE.

  Widget _buildImageHeader(BuildContext context, String title, String imageUrl) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Stack(
      children: [
        Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, colors.shadow.withOpacity(0.8)],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 16,
          left: 16,
          right: 16,
          child: Text(
            title,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: colors.onInverseSurface,
              shadows: [Shadow(color: colors.shadow.withOpacity(0.5), blurRadius: 4)],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomActionBar(BuildContext context, EventDetailsProvider provider) {
    final colors = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    final bool isSubscribed = provider.isSubscribed;
    final bool isLoading = provider.isSubscribing;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(color: colors.shadow.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -2)),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: isLoading ? null : () => _handleDonate(context),
              icon: const Icon(Icons.favorite_border, size: 18),
              label: const Text('Donar'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: isSubscribed
                ? OutlinedButton(
              onPressed: isLoading ? null : () => _handleUnsubscribe(context),
              style: OutlinedButton.styleFrom(
                foregroundColor: colors.error,
                side: BorderSide(color: colors.error),
                padding: isLoading ? const EdgeInsets.all(12) : null,
              ),
              child: isLoading
                  ? SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: colors.error))
                  : const Text('Cancelar suscripción'),
            )
                : ElevatedButton(
              onPressed: isLoading ? null : () => _handleRegister(context),
              style: ElevatedButton.styleFrom(padding: isLoading ? const EdgeInsets.all(12) : null),
              child: isLoading
                  ? SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: theme.colorScheme.onPrimary))
                  : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.edit_note, size: 18),
                  SizedBox(width: 8),
                  Text('Inscribirse'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleDonate(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => DonationDialog(kitchenId: widget.kitchenId),
    );
  }

  void _handleRegister(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar inscripción'),
        content: const Text('¿Deseas inscribirte como voluntario en esta cocina?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final provider = context.read<EventDetailsProvider>();
              final success = await provider.subscribe(widget.kitchenId);
              if (!mounted) return;
              if (success) {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    icon: const Icon(Icons.check_circle, color: Colors.green, size: 48),
                    title: const Text('¡Inscrito!'),
                    content: const Text('Te has inscrito exitosamente.'),
                    actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Aceptar'))],
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(provider.errorMessage ?? 'Error.'), backgroundColor: Colors.red));
              }
            },
            child: const Text('Inscribirse'),
          ),
        ],
      ),
    );
  }

  void _handleUnsubscribe(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancelar suscripción'),
        content: const Text('¿Estás seguro de que quieres dejar de ser voluntario en esta cocina?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Volver')),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(context);
              final provider = context.read<EventDetailsProvider>();
              final success = await provider.unsubscribe(widget.kitchenId);
              if (!mounted) return;
              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Has cancelado tu suscripción.')));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(provider.errorMessage ?? 'Error.'), backgroundColor: Colors.red));
              }
            },
            child: const Text('Cancelar suscripción'),
          ),
        ],
      ),
    );
  }
}