import 'package:bienestar_integral_app/features/events/presentation/widgets/event_info_row.dart';
import 'package:bienestar_integral_app/features/events/presentation/widgets/success_dialog.dart';
import 'package:bienestar_integral_app/features/profile/presentation/widgets/confirmation_dialog.dart';
import 'package:bienestar_integral_app/features/settings/presentation/widgets/home_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EventDetailScreen extends StatelessWidget {
  const EventDetailScreen({super.key});

  void _handleAttend(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => ConfirmationDialog(
        title: 'Confirmar inscripción',
        message: '¿Deseas unirte como voluntario a este evento?',
        confirmText: 'Confirmar',
        onConfirm: () => showDialog(
          context: context,
          builder: (_) => const SuccessDialog(message: '¡Inscripción al evento ha sido exitosa!'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Recibir datos del sub-evento
    final eventData = GoRouterState.of(context).extra as Map<String, String>? ??
        {
          'title': 'Evento Detallado',
          'description': 'Descripción detallada del evento no disponible.',
          'date': 'Sin fecha',
        };

    // Datos de ejemplo
    const location = 'Calzada al sumidero, enfrente Bodega Aurrera';
    const time = 'De 02:30 pm a 5:00 pm';
    const coordinators = '2 Coordinadores';
    const volunteers = '13 Voluntarios extras';

    return Scaffold(
      appBar: const HomeAppBar(title: 'Detalle del Evento', showBackButton: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(eventData['title']!, style: theme.textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text(eventData['description']!, style: theme.textTheme.bodyLarge),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: theme.colorScheme.outline.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  EventInfoRow(icon: Icons.calendar_today, label: 'Fecha', value: eventData['date']!),
                  EventInfoRow(icon: Icons.access_time, label: 'Horario', value: time),
                  EventInfoRow(icon: Icons.location_on, label: 'Ubicación', value: location),
                  EventInfoRow(icon: Icons.people, label: 'Capacidad de Voluntarios', value: '$coordinators\n$volunteers'),
                ],
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _handleAttend(context),
                icon: const Icon(Icons.edit_note),
                label: const Text('Asistir al evento'),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                'Evento gratuito',
                style: theme.textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic),
              ),
            ),
          ],
        ),
      ),
    );
  }
}