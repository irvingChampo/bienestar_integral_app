import 'package:flutter/material.dart';

class EventCardAdmin extends StatelessWidget {
  final String title; // <-- CAMBIO: Antes era eventNumber
  final String description;
  final String date;
  final String currentCount;
  final String maxCount;

  const EventCardAdmin({
    super.key,
    required this.title, // <-- CAMBIO
    required this.description,
    required this.date,
    required this.currentCount,
    required this.maxCount,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      color: colors.primary,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded( // Agregamos Expanded para evitar desbordamiento si el nombre es largo
                  child: Text(
                    title, // <-- CAMBIO: Muestra el nombre real (ej: "Cena de navidad")
                    style: textTheme.titleLarge?.copyWith(
                      color: colors.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: colors.onPrimary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$currentCount/$maxCount',
                    style: textTheme.labelMedium?.copyWith(color: colors.onPrimary),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Descripción: $description',
              style: textTheme.bodyMedium?.copyWith(color: colors.onPrimary, height: 1.5),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Fecha: $date',
                style: textTheme.bodyMedium?.copyWith(
                  color: colors.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}