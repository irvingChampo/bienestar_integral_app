import 'package:flutter/material.dart';

class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Se obtiene el colorScheme para usar colores semánticos.
    final colors = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // CAMBIO: Se usa un color del tema en lugar de un gris específico.
            Icon(icon, size: 80, color: colors.surfaceVariant), // ANTES: Colors.grey.shade400
            const SizedBox(height: 16),
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                // CAMBIO: Se usa un color del tema.
                color: colors.onSurfaceVariant, // ANTES: Colors.grey.shade600
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                // CAMBIO: Se usa un color del tema.
                color: colors.outline, // ANTES: Colors.grey.shade500
              ),
            ),
          ],
        ),
      ),
    );
  }
}