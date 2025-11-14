import 'package:bienestar_integral_app/core/router/routes.dart';
import 'package:bienestar_integral_app/features/events/presentation/widgets/event_item_card.dart';
import 'package:bienestar_integral_app/features/settings/presentation/widgets/home_app_bar.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EventDetailsScreen extends StatelessWidget {
  const EventDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final eventData = GoRouterState.of(context).extra as Map<String, String>? ??
        {
          'title': 'Evento de Cocina',
          'organizer': 'Organizador Anónimo',
          'schedule': 'Sin horario definido',
          'image': 'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?w=800',
        };

    final List<Map<String, String>> subEvents = [
      {'title': 'Cena Navideña', 'description': 'Apoyo en la preparación y servicio de la cena.', 'date': '24/12/2025', 'attending': '5/20'},
      {'title': 'Desayuno de Año Nuevo', 'description': 'Ayuda para servir el primer desayuno del año.', 'date': '01/01/2026', 'attending': '2/15'},
    ];

    return Scaffold(
      appBar: const HomeAppBar(title: 'Bienestar Integral', showBackButton: true),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildImageHeader(context, eventData),
                  _buildScheduleBar(context, eventData),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: subEvents.map((event) {
                        return EventItemCard(
                          title: event['title']!,
                          description: event['description']!,
                          date: event['date']!,
                          attending: event['attending']!,
                          onTap: () => context.push(AppRoutes.eventDetailPath, extra: event),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          _buildBottomActionBar(context),
        ],
      ),
    );
  }

  Widget _buildImageHeader(BuildContext context, Map<String, String> eventData) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Stack(
      children: [
        Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(eventData['image']!),
              fit: BoxFit.cover,
            ),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  eventData['title']!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Organizado por: ${eventData['organizer'] ?? eventData['title']}',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colors.onInverseSurface,
                  shadows: [Shadow(color: colors.shadow.withOpacity(0.5), blurRadius: 4)],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildScheduleBar(BuildContext context, Map<String, String> eventData) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
      child: Row(
        children: [
          Text(
            'Horarios:',
            style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              eventData['schedule'] ?? 'martes, 5:30 a.m.-5p.m.',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActionBar(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(20),
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
      desc: '¿Deseas realizar una donación para este evento?',
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
      desc: '¿Deseas inscribirte como voluntario a este evento?',
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