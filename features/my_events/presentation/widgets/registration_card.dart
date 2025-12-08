import 'package:bienestar_integral_app/features/events/domain/entities/event_registration.dart';
import 'package:flutter/material.dart';

class RegistrationCard extends StatelessWidget {
  final EventRegistration registration;
  final VoidCallback onCancel;
  final bool isLoading;

  const RegistrationCard({
    super.key,
    required this.registration,
    required this.onCancel,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final event = registration.event;

    // Datos seguros
    final eventName = event?.name ?? 'Evento desconocido';
    final eventDate = event?.eventDate ?? 'Fecha pendiente';
    final eventTime = event?.startTime ?? '--:--';
    final description = event?.description ?? 'Sin descripción';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
        // Borde izquierdo amarillo (Estilo HTML .event-card border-left)
        border: Border(
          left: BorderSide(color: colors.primary, width: 4),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Header: Icono + Título + Fecha
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icono en caja degradada
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [colors.primary, colors.primaryContainer],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: colors.primary.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.event, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 15),
                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        eventName,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.calendar_today, size: 14, color: colors.outline),
                          const SizedBox(width: 6),
                          Text(
                            '$eventDate • $eventTime',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Divisor (Estilo HTML .event-divider)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Container(
                height: 1,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [colors.primary, Colors.transparent],
                  ),
                ),
              ),
            ),

            // Caja de Estado / Descripción (Estilo HTML .event-status)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colors.primary.withOpacity(0.1), // Fondo amarillo muy claro
                borderRadius: BorderRadius.circular(10),
                border: Border(
                  left: BorderSide(color: colors.primary, width: 3),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.info, size: 20, color: colors.primary),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      description, // Usamos la descripción como texto de estado
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            // Botón Cancelar (Estilo HTML .cancel-button)
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: isLoading ? null : onCancel,
                style: OutlinedButton.styleFrom(
                  foregroundColor: colors.error, // Rojo
                  side: BorderSide(color: colors.error, width: 2), // Borde rojo grueso
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: isLoading
                    ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2, color: colors.error),
                )
                    : const Text(
                  'Cancelar asistencia',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}