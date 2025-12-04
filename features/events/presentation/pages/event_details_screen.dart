// features/events/presentation/pages/event_details_screen.dart (READAPTADO)

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:bienestar_integral_app/features/events/presentation/providers/event_details_provider.dart';
import 'package:bienestar_integral_app/features/events/presentation/widgets/event_info_row.dart'; // Reutilizamos este widget
import 'package:bienestar_integral_app/features/home/domain/entities/kitchen_detail.dart';
import 'package:bienestar_integral_app/features/settings/presentation/widgets/home_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventDetailsScreen extends StatefulWidget {
  final int kitchenId;
  final Map<String, String>? initialData; // Datos básicos pasados desde el listado

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
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<EventDetailsProvider>();

    return Scaffold(
      appBar: const HomeAppBar(title: 'Detalles de la Cocina', showBackButton: true),
      body: _buildBody(provider),
      bottomNavigationBar: _buildBottomActionBar(context),
    );
  }

  Widget _buildBody(EventDetailsProvider provider) {
    switch (provider.status) {
      case EventDetailsStatus.loading:
      // Mostramos un spinner y la información inicial si está disponible
        return _buildContent(null, isLoading: true);
      case EventDetailsStatus.error:
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text(
              provider.errorMessage ?? 'Error al cargar los detalles',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        );
      case EventDetailsStatus.initial:
      case EventDetailsStatus.success:
        if (provider.kitchenDetail == null) {
          return const Center(child: Text('No se encontraron detalles de la cocina.'));
        }
        return _buildContent(provider.kitchenDetail!);
    }
  }

  Widget _buildContent(KitchenDetail? kitchenDetail, {bool isLoading = false}) {
    final theme = Theme.of(context);

    // Usamos los datos reales del API, o el initialData/placeholders si no han cargado
    final name = kitchenDetail?.name ?? widget.initialData?['title'] ?? 'Cargando...';
    final description = kitchenDetail?.description ?? widget.initialData?['description'] ?? 'Sin descripción disponible.';
    // La imagen la tomamos de initialData, ya que el endpoint de detalles da null para imageUrl.
    final imageUrl = widget.initialData?['image'] ?? 'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?w=800';

    final streetAddress = kitchenDetail?.location.streetAddress ?? 'Dirección no disponible';
    final neighborhood = kitchenDetail?.location.neighborhood ?? 'Colonia no disponible'; // Nuevo campo
    final contactPhone = kitchenDetail?.contactPhone ?? 'No disponible'; // Accedemos directamente a kitchenDetail
    final contactEmail = kitchenDetail?.contactEmail ?? 'No disponible'; // Accedemos directamente a kitchenDetail

    // Los horarios no están en el JSON, se mantiene como placeholder.
    const String schedule = 'Lunes a Viernes, 9:00 AM - 5:00 PM';
    // const String capacity = '2 Coordinadores, 13 Voluntarios extras'; // No está en el JSON de detalles.

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 24.0), // Padding para no ocultar contenido con la bottom bar
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
                // Información de ubicación
                EventInfoRow(icon: Icons.location_on, label: 'Dirección', value: streetAddress),
                const SizedBox(height: 12),
                EventInfoRow(icon: Icons.location_city, label: 'Colonia', value: neighborhood),
                const SizedBox(height: 12),
                // Información de contacto
                EventInfoRow(icon: Icons.phone, label: 'Teléfono de Contacto', value: contactPhone),
                const SizedBox(height: 12),
                EventInfoRow(icon: Icons.email, label: 'Correo de Contacto', value: contactEmail),
                const SizedBox(height: 12),
                // Horarios (manteniendo placeholder por no estar en JSON)
                EventInfoRow(icon: Icons.schedule, label: 'Horarios de Operación', value: schedule),

                // Si la API tuviera capacidad, se añadiría aquí.
                // const SizedBox(height: 12),
                // EventInfoRow(icon: Icons.people, label: 'Capacidad de Voluntarios', value: capacity),
              ],
            ),
          ),
          if (isLoading) const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator())),
        ],
      ),
    );
  }

  // Se extrae esta parte del código del KitchenDetailModel para simplificar el acceso a campos.
  // Esto es una simplificación temporal. Idealmente, KitchenDetail incluiría estos campos directamente.
  // NO se está usando ya que se corrigió el modelo.
  // String _getFieldValue(KitchenDetail? detail, String fieldName, {String defaultValue = 'No disponible'}) {
  //   if (detail == null) return defaultValue;
  //   switch (fieldName) {
  //     case 'contactPhone': return detail.contactPhone ?? defaultValue;
  //     case 'contactEmail': return detail.contactEmail ?? defaultValue;
  //     case 'neighborhood': return detail.location?.neighborhood ?? defaultValue;
  //     default: return defaultValue;
  //   }
  // }


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

  // Los métodos _buildInfoRow, _buildBottomActionBar, _handleDonate, _handleRegister
  // se mantienen igual que en la versión anterior.

  Widget _buildBottomActionBar(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32), // Padding inferior para safe area
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
              onPressed: () => _handleDonate(context),
              icon: const Icon(Icons.favorite_border, size: 18),
              label: const Text('Donar'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => _handleRegister(context),
              icon: const Icon(Icons.edit_note, size: 18),
              label: const Text('Inscribirse'),
            ),
          ),
        ],
      ),
    );
  }

  void _handleDonate(BuildContext context) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.question,
      animType: AnimType.bottomSlide,
      title: 'Confirmar donación',
      desc: '¿Deseas realizar una donación para esta cocina?',
      btnCancelOnPress: () {},
      btnOkText: 'Donar',
      btnOkOnPress: () {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          animType: AnimType.scale,
          title: '¡Gracias!',
          desc: '¡Gracias por tu donación!',
          btnOkOnPress: () {},
        ).show();
      },
    ).show();
  }

  void _handleRegister(BuildContext context) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.question,
      animType: AnimType.bottomSlide,
      title: 'Confirmar inscripción',
      desc: '¿Deseas inscribirte como voluntario en esta cocina?',
      btnCancelOnPress: () {},
      btnOkText: 'Inscribirse',
      btnOkOnPress: () {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          animType: AnimType.scale,
          title: '¡Inscrito!',
          desc: '¡Te has inscrito exitosamente!',
          btnOkOnPress: () {},
        ).show();
      },
    ).show();
  }
}