import 'package:flutter/material.dart';

class InventoryItemCard extends StatelessWidget {
  final String name;
  final String quantity;
  final String status;

  const InventoryItemCard({
    super.key,
    required this.name,
    required this.quantity,
    required this.status,
  });

  // Función para determinar el color del estado
  Color _getStatusColor(String status, ColorScheme colors) {
    switch (status.toLowerCase()) {
      case 'bajo stock':
        return colors.error;
      case 'perecedero':
        return colors.secondary;
      default:
        return colors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    final statusColor = _getStatusColor(status, colors);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colors.outline.withOpacity(0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: textTheme.titleMedium),
                const SizedBox(height: 4),
                Text('Cantidad: $quantity', style: textTheme.bodyMedium?.copyWith(color: colors.onSurfaceVariant)),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                status,
                style: textTheme.labelSmall?.copyWith(color: statusColor, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}