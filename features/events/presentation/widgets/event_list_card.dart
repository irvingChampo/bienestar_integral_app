import 'package:bienestar_integral_app/features/events/domain/entities/event.dart';
import 'package:flutter/material.dart';

class EventListCard extends StatelessWidget {
  final Event event;
  final VoidCallback onJoin;
  final VoidCallback onLeave;
  final bool isLoading;
  final bool isRegistered;

  const EventListCard({
    super.key,
    required this.event,
    required this.onJoin,
    required this.onLeave,
    this.isLoading = false,
    this.isRegistered = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    // Color suavizado para iconos y botones en modo oscuro
    final primarySoft = isDark ? colors.primary.withOpacity(0.8) : colors.primary;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                    color: colors.primaryContainer.withOpacity(isDark ? 0.5 : 1.0),
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
            Text(
              event.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: primarySoft),
                const SizedBox(width: 4),
                Text(event.eventDate, style: theme.textTheme.bodySmall),
                const SizedBox(width: 16),
                Icon(Icons.access_time, size: 16, color: primarySoft),
                const SizedBox(width: 4),
                Text('${event.startTime} - ${event.endTime}', style: theme.textTheme.bodySmall),
              ],
            ),
            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: isRegistered
                  ? OutlinedButton.icon(
                onPressed: isLoading ? null : onLeave,
                style: OutlinedButton.styleFrom(
                  foregroundColor: colors.error,
                  side: BorderSide(color: colors.error),
                ),
                icon: isLoading
                    ? SizedBox(height: 16, width: 16, child: CircularProgressIndicator(strokeWidth: 2, color: colors.error))
                    : const Icon(Icons.close),
                label: const Text('Cancelar asistencia'),
              )
                  : ElevatedButton(
                onPressed: isLoading ? null : onJoin,
                style: ElevatedButton.styleFrom(
                  // AQUÍ APLICAMOS EL COLOR SUAVIZADO
                  backgroundColor: primarySoft,
                  foregroundColor: colors.onPrimary,
                  elevation: 0,
                ),
                child: isLoading
                    ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: colors.onPrimary,
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