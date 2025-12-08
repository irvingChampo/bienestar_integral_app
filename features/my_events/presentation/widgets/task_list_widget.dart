import 'package:flutter/material.dart';

class TaskListWidget extends StatelessWidget {
  final List<String> tasks;

  const TaskListWidget({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tareas asignadas:',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 4),
        ...tasks.map((task) => Padding(
          padding: const EdgeInsets.only(left: 8, top: 4),
          child: Text(
            '• $task',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontStyle: FontStyle.italic,
            ),
          ),
        )).toList(),
      ],
    );
  }
}