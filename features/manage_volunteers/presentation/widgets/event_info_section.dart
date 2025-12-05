import 'package:flutter/material.dart';

class EventInfoSection extends StatelessWidget {
  final String description;
  final String dayName;
  final String dayNumber;
  final String monthYear;
  final String startTime;
  final String endTime;
  final String location; // Ahora usaremos esto para "Detalles"
  final int coordinators;
  final int volunteers;

  const EventInfoSection({
    super.key,
    required this.description,
    required this.dayName,
    required this.dayNumber,
    required this.monthYear,
    required this.startTime,
    required this.endTime,
    required this.location,
    required this.coordinators,
    required this.volunteers,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: colors.outline.withOpacity(0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                description,
                style: textTheme.bodyMedium?.copyWith(
                    fontStyle: FontStyle.italic,
                    color: colors.onSurfaceVariant
                )
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: colors.outline.withOpacity(0.5)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Text(dayName, style: textTheme.labelLarge),
                      const SizedBox(height: 4),
                      Text(dayNumber, style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(monthYear, style: textTheme.labelSmall),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('De $startTime', style: textTheme.bodyLarge),
                      const SizedBox(height: 4),
                      Text('a $endTime', style: textTheme.bodyLarge),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 16),

            // --- CAMBIO AQUÍ: Cambiamos "Donde:" por "Detalles:" ---
            _buildRichText('Detalles:\n', location, textTheme),

            const SizedBox(height: 16),
            _buildRichText(
              'Capacidad de voluntarios:\n',
              '$volunteers Voluntarios requeridos', // Simplificamos para mostrar el total
              textTheme,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRichText(String title, String body, TextTheme textTheme) {
    return RichText(
      text: TextSpan(
        style: textTheme.bodyMedium?.copyWith(color: Colors.black87), // Aseguramos color legible
        children: [
          TextSpan(text: title, style: const TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: body),
        ],
      ),
    );
  }
}