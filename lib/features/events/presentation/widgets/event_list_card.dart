import 'package:bienestar_integral_app/features/events/domain/entities/event.dart';
import 'package:flutter/material.dart';

class EventListCard extends StatelessWidget {
  final Event event;
  final VoidCallback onJoin;
  final bool isLoading;

  const EventListCard({
    super.key,
    required this.event,
    required this.onJoin,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Fila superior: Nombre y Capacidad
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    event.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: colors.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Cupo: ${event.maxCapacity}',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colors.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Descripción
            Text(
              event.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
            ),
            const SizedBox(height: 12),

            // Fila de Fecha y Hora (ACTUALIZADA)
            Row(
              children: [
                // Fecha
                Icon(Icons.calendar_today, size: 16, color: colors.primary),
                const SizedBox(width: 4),
                Text(event.eventDate, style: theme.textTheme.bodySmall),

                const SizedBox(width: 16),

                // Hora (Inicio - Fin)
                Icon(Icons.access_time, size: 16, color: colors.primary),
                const SizedBox(width: 4),
                Text(
                  '${event.startTime} - ${event.endTime}', // <-- CAMBIO AQUÍ
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Botón de Acción
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : onJoin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.surfaceVariant,
                  foregroundColor: colors.onSurfaceVariant,
                  elevation: 0,
                ),
                child: isLoading
                    ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: colors.onSurfaceVariant,
                  ),
                )
                    : const Text('Asistir a este evento'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}