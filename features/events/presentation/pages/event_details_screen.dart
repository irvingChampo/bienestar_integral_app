import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:bienestar_integral_app/features/events/domain/entities/event.dart';
import 'package:bienestar_integral_app/features/events/presentation/providers/event_details_provider.dart';
import 'package:bienestar_integral_app/features/events/presentation/providers/events_provider.dart';
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

  void _handleJoinEvent(Event event) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.question,
      animType: AnimType.bottomSlide,
      title: 'Confirmar asistencia',
      desc: '¿Deseas inscribirte al evento "${event.name}"?',
      btnCancelOnPress: () {},
      btnOkText: 'Sí, asistir',
      btnOkOnPress: () async {
        final eventsProvider = context.read<EventsProvider>();
        final success = await eventsProvider.joinEvent(event.id);

        if (!mounted) return;
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('¡Inscrito correctamente!'), backgroundColor: Colors.green),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(eventsProvider.errorMessage ?? 'Error'), backgroundColor: Colors.red),
          );
        }
      },
    ).show();
  }

  void _handleLeaveEvent(Event event) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.bottomSlide,
      title: 'Cancelar asistencia',
      desc: '¿Ya no podrás asistir a "${event.name}"?',
      btnCancelOnPress: () {},
      btnOkText: 'Cancelar registro',
      btnOkColor: Colors.red,
      btnOkOnPress: () async {
        final eventsProvider = context.read<EventsProvider>();
        final success = await eventsProvider.leaveEvent(event.id);

        if (!mounted) return;
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Asistencia cancelada.')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(eventsProvider.errorMessage ?? 'Error'), backgroundColor: Colors.red),
          );
        }
      },
    ).show();
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
      title: 'Confirmar inscripción',
      desc: '¿Deseas unirte como voluntario recurrente?',
      btnCancelOnPress: () {},
      btnOkText: 'Unirme',
      btnOkOnPress: () async {
        final provider = context.read<EventDetailsProvider>();
        final success = await provider.subscribe(widget.kitchenId);
        if (success && mounted) {
          AwesomeDialog(context: context, dialogType: DialogType.success, title: '¡Bienvenido!', desc: 'Te has unido al equipo.').show();
        }
      },
    ).show();
  }

  void _showUnsubscribeDialog() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      title: 'Salir de la cocina',
      desc: '¿Dejar de ser voluntario recurrente?',
      btnCancelOnPress: () {},
      btnOkText: 'Salir',
      btnOkColor: Colors.red,
      btnOkOnPress: () => context.read<EventDetailsProvider>().unsubscribe(widget.kitchenId),
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    final detailsProvider = context.watch<EventDetailsProvider>();
    final eventsProvider = context.watch<EventsProvider>();

    return Scaffold(
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
    final name = detailsProvider.kitchenDetail?.name ?? widget.initialData?['title'] ?? 'Cargando...';
    final imageUrl = widget.initialData?['image'] ?? 'https://images.unsplash.com/photo-1556910103-1c02745a30bf?w=800';
    final kitchen = detailsProvider.kitchenDetail;
    final colors = Theme.of(context).colorScheme;

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: KitchenDetailHeader(title: name, imageUrl: imageUrl)),
        SliverPadding(
          padding: const EdgeInsets.all(20),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              Text('Descripción', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),

              // --- CORRECCIÓN AQUÍ: Color adaptable para el texto ---
              Text(
                  kitchen?.description ?? widget.initialData?['description'] ?? '...',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      height: 1.6,
                      color: colors.onSurfaceVariant // Antes era Colors.black54 (fijo)
                  )
              ),
              // -----------------------------------------------------

              const SizedBox(height: 24),
              Divider(color: colors.primary.withOpacity(0.5), thickness: 1),
              const SizedBox(height: 24),
              if (kitchen != null) ...[
                KitchenInfoItem(icon: Icons.location_on, label: 'Dirección', value: kitchen.location.streetAddress),
                KitchenInfoItem(icon: Icons.map, label: 'Colonia', value: kitchen.location.neighborhood),
                if (kitchen.contactPhone != null) KitchenInfoItem(icon: Icons.phone, label: 'Teléfono', value: kitchen.contactPhone!),
              ] else if (detailsProvider.status == EventDetailsStatus.loading) ...[
                const Center(child: CircularProgressIndicator())
              ],
              const SizedBox(height: 32),
              Text('Próximos Eventos', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              if (eventsProvider.status == EventsStatus.loading)
                const Center(child: CircularProgressIndicator())
              else if (eventsProvider.events.isEmpty)
                const Center(child: Text('No hay eventos disponibles.'))
              else
                ...eventsProvider.events.map((event) => EventListCard(
                  event: event,
                  isLoading: eventsProvider.processingEventId == event.id,
                  isRegistered: eventsProvider.isRegistered(event.id),
                  onJoin: () => _handleJoinEvent(event),
                  onLeave: () => _handleLeaveEvent(event),
                )),
              const SizedBox(height: 80),
            ]),
          ),
        ),
      ],
    );
  }
}