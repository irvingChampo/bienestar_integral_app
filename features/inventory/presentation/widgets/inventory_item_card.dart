import 'package:bienestar_integral_app/features/inventory/domain/entities/inventory_item.dart';
import 'package:flutter/material.dart';

class InventoryItemCard extends StatelessWidget {
  final InventoryItem item;
  final VoidCallback onAddStock;
  final VoidCallback onRemoveStock;
  final VoidCallback onSetStock; // (+) Nuevo callback para fijar stock
  final VoidCallback onEdit;     // (+) Nuevo callback para editar
  final VoidCallback onDelete;

  const InventoryItemCard({
    super.key,
    required this.item,
    required this.onAddStock,
    required this.onRemoveStock,
    required this.onSetStock,
    required this.onEdit,
    required this.onDelete,
  });

  Color _getStatusColor(double quantity, ColorScheme colors) {
    if (quantity <= 0) return colors.error;
    if (quantity < 10) return colors.secondary;
    return colors.primary;
  }

  String _getStatusText(double quantity) {
    if (quantity <= 0) return 'Agotado';
    if (quantity < 10) return 'Bajo stock';
    return 'Disponible';
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    final statusColor = _getStatusColor(item.quantity, colors);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colors.outline.withOpacity(0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.product.name, style: textTheme.titleMedium),
                      const SizedBox(height: 4),

                      // CANTIDAD CLICKEABLE (Funcionalidad Set Stock)
                      InkWell(
                        onTap: onSetStock,
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: colors.surfaceVariant.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: colors.outline.withOpacity(0.2)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${item.quantity} ${item.product.unit}',
                                style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(width: 4),
                              Icon(Icons.edit, size: 14, color: colors.onSurfaceVariant),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Badge de Estado
                Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _getStatusText(item.quantity),
                    style: textTheme.labelSmall?.copyWith(color: statusColor, fontWeight: FontWeight.bold),
                  ),
                ),

                // Menú de opciones (Editar / Eliminar)
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert),
                  onSelected: (v) {
                    if (v == 'edit') onEdit();
                    if (v == 'delete') onDelete();
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit_note, size: 20),
                          SizedBox(width: 12),
                          Text('Editar datos'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete_outline, size: 20, color: Colors.red),
                          SizedBox(width: 12),
                          Text('Eliminar', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('Ajuste rápido: ', style: textTheme.bodySmall),
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                  onPressed: onRemoveStock,
                  tooltip: '-1',
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline, color: Colors.green),
                  onPressed: onAddStock,
                  tooltip: '+1',
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}