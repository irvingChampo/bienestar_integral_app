import 'package:bienestar_integral_app/features/events/presentation/widgets/success_dialog.dart';
import 'package:bienestar_integral_app/features/my_events/presentation/widgets/empty_state_widget.dart';
import 'package:bienestar_integral_app/features/my_events/presentation/widgets/my_event_card.dart';
import 'package:bienestar_integral_app/features/profile/presentation/widgets/confirmation_dialog.dart';
import 'package:bienestar_integral_app/features/settings/presentation/widgets/home_app_bar.dart';
import 'package:flutter/material.dart';

class MyEventsScreen extends StatefulWidget {
  const MyEventsScreen({super.key});

  @override
  State<MyEventsScreen> createState() => _MyEventsScreenState();
}

class _MyEventsScreenState extends State<MyEventsScreen> {
  // Datos de ejemplo
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
    return Scaffold(
      appBar: const HomeAppBar(title: 'Mis Eventos', showBackButton: true),
      body: _myEvents.isEmpty
          ? const EmptyStateWidget(
        icon: Icons.event_busy,
        title: 'No tienes eventos registrados',
        subtitle: 'Los eventos a los que te registres aparecerán aquí',
      )
          : ListView.builder(
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
      ),
    );
  }
}