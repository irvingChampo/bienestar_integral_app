import 'package:bienestar_integral_app/features/events/presentation/widgets/event_info_row.dart';
import 'package:bienestar_integral_app/features/my_events/presentation/widgets/task_list_widget.dart';
import 'package:flutter/material.dart';

class MyEventCard extends StatelessWidget {
  final String eventName;
  final String date;
  final String time;
  final String location;
  final List<String> tasks;
  final VoidCallback onMarkComplete;

  const MyEventCard({
    super.key,
    required this.eventName,
    required this.date,
    required this.time,
    required this.location,
    required this.tasks,
    required this.onMarkComplete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.tertiaryContainer.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.tertiaryContainer,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EventInfoRow(icon: Icons.event, label: 'Evento', value: eventName),
          EventInfoRow(icon: Icons.calendar_today, label: 'Fecha', value: date),
          EventInfoRow(icon: Icons.access_time, label: 'Hora', value: time),
          EventInfoRow(icon: Icons.location_on, label: 'Lugar', value: location),
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 12),
          TaskListWidget(tasks: tasks),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onMarkComplete,
              child: const Text('Marcar tarea como completada'),
            ),
          ),
        ],
      ),
    );
  }
}