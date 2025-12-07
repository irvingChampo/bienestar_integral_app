import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:bienestar_integral_app/features/events/domain/entities/event.dart';
import 'package:bienestar_integral_app/features/events/presentation/providers/event_details_provider.dart';
import 'package:bienestar_integral_app/features/events/presentation/providers/events_provider.dart';
// Importamos los nuevos widgets de diseño
import 'package:bienestar_integral_app/features/events/presentation/widgets/kitchen_detail_header.dart';
import 'package:bienestar_integral_app/features/events/presentation/widgets/kitchen_info_item.dart';
import 'package:bienestar_integral_app/features/events/presentation/widgets/kitchen_action_bar.dart';
import 'package:bienestar_integral_app/features/events/presentation/widgets/event_list_card.dart';
import 'package:bienestar_integral_app/features/home/domain/entities/kitchen_detail.dart';
import 'package:bienestar_integral_app/features/payments/presentation/widgets/donation_dialog.dart';
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
      context.read<EventDetailsProvider>().fetchKitchenDetails(widget.kitchenId);
      context.read<EventsProvider>().fetchEventsByKitchen(widget.kitchenId);
    });
  }

  // --- LÓGICA DE NEGOCIO (INTACTA) ---
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

  void _handleDonate() {
    showDialog(
      context: context,
      builder: (context) => DonationDialog(kitchenId: widget.kitchenId),
    );
  }

  void _handleSubscriptionAction(bool isSubscribed) {
    if (isSubscribed) {
      _showUnsubscribeDialog();
    } else {
      _showSubscribeDialog();
    }
  }

  void _showSubscribeDialog() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.question,
      animType: AnimType.bottomSlide,
      title: 'Confirmar inscripción',
      desc: '¿Deseas inscribirte como voluntario recurrente en esta cocina?',
      btnCancelOnPress: () {},
      btnOkText: 'Inscribirse',
      btnOkOnPress: () async {
        final provider = context.read<EventDetailsProvider>();
        final success = await provider.subscribe(widget.kitchenId);
        if (!mounted) return;
        if (success) {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.success,
            animType: AnimType.scale,
            title: '¡Inscrito!',
            desc: 'Te has unido al equipo de voluntarios.',
            btnOkOnPress: () {},
          ).show();
        }
      },
    ).show();
  }

  void _showUnsubscribeDialog() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.bottomSlide,
      title: 'Cancelar suscripción',
      desc: '¿Estás seguro de que quieres dejar de ser voluntario en esta cocina?',
      btnCancelOnPress: () {},
      btnOkText: 'Sí, salir',
      btnOkColor: Colors.red,
      btnOkOnPress: () async {
        final provider = context.read<EventDetailsProvider>();
        await provider.unsubscribe(widget.kitchenId);
      },
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    final detailsProvider = context.watch<EventDetailsProvider>();
    final eventsProvider = context.watch<EventsProvider>();

    return Scaffold(
      // Extendemos el cuerpo detrás del AppBar (que quitamos) para el efecto Hero
      body: _buildBody(detailsProvider, eventsProvider),
      bottomNavigationBar: KitchenActionBar(
        onDonate: _handleDonate,
        onSubscribe: () => _handleSubscriptionAction(detailsProvider.isSubscribed),
        isSubscribed: detailsProvider.isSubscribed,
        isLoading: detailsProvider.isSubscribing,
      ),
    );
  }

  Widget _buildBody(EventDetailsProvider detailsProvider, EventsProvider eventsProvider) {
    // Datos precargados o valores por defecto para no mostrar pantalla blanca
    final name = detailsProvider.kitchenDetail?.name ?? widget.initialData?['title'] ?? 'Cargando...';
    final imageUrl = widget.initialData?['image'] ?? 'https://images.unsplash.com/photo-1556910103-1c02745a30bf?w=800';

    // Si aún está cargando los detalles completos, mostramos la estructura básica
    final kitchen = detailsProvider.kitchenDetail;

    return CustomScrollView(
      slivers: [
        // 1. Header que desaparece al hacer scroll (opcional, aquí usamos SliverToBoxAdapter para simplicidad con nuestro custom widget)
        SliverToBoxAdapter(
          child: KitchenDetailHeader(
            title: name,
            imageUrl: imageUrl,
          ),
        ),

        // 2. Contenido
        SliverPadding(
          padding: const EdgeInsets.all(20),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              // Descripción
              Text(
                'Descripción',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                kitchen?.description ?? widget.initialData?['description'] ?? 'Cargando información detallada...',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.6, color: Colors.black54),
              ),
              const SizedBox(height: 24),

              // Divisor visual (como en HTML)
              Divider(color: Theme.of(context).colorScheme.primary.withOpacity(0.5), thickness: 1),
              const SizedBox(height: 24),

              // Lista de Detalles (KitchenInfoItem)
              if (kitchen != null) ...[
                KitchenInfoItem(
                    icon: Icons.location_on,
                    label: 'Dirección',
                    value: kitchen.location.streetAddress
                ),
                KitchenInfoItem(
                    icon: Icons.map,
                    label: 'Colonia',
                    value: kitchen.location.neighborhood
                ),
                if (kitchen.contactPhone != null)
                  KitchenInfoItem(
                      icon: Icons.phone,
                      label: 'Teléfono',
                      value: kitchen.contactPhone!
                  ),
                if (kitchen.contactEmail != null)
                  KitchenInfoItem(
                      icon: Icons.email,
                      label: 'Correo',
                      value: kitchen.contactEmail!
                  ),
                const KitchenInfoItem(
                    icon: Icons.access_time,
                    label: 'Horario',
                    value: 'Lunes a Viernes, 9:00 AM - 5:00 PM' // Dato estático o del backend si existe
                ),
              ] else if (detailsProvider.status == EventDetailsStatus.loading) ...[
                const Center(child: CircularProgressIndicator())
              ],

              const SizedBox(height: 32),

              // Sección de Eventos
              Text(
                'Próximos Eventos',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // Estado de los eventos (Empty / List)
              if (eventsProvider.status == EventsStatus.loading)
                const Center(child: CircularProgressIndicator())
              else if (eventsProvider.events.isEmpty)
              // Empty State estilizado como en el HTML (Caja dashed)
                Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.5),
                      style: BorderStyle.solid, // Flutter no tiene dashed nativo fácil, usamos sólido gris suave
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.event_busy, size: 48, color: Colors.grey.withOpacity(0.5)),
                      const SizedBox(height: 12),
                      const Text(
                        'No hay eventos programados próximamente.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                )
              else
                ...eventsProvider.events.map((event) => EventListCard(
                  event: event,
                  isLoading: eventsProvider.processingEventId == event.id,
                  onJoin: () => _handleJoinEvent(event),
                )),

              const SizedBox(height: 80), // Espacio para que no lo tape el botón flotante
            ]),
          ),
        ),
      ],
    );
  }
}