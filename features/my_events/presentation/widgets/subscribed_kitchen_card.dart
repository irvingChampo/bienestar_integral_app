import 'package:bienestar_integral_app/features/home/domain/entities/kitchen.dart';
import 'package:flutter/material.dart';

class SubscribedKitchenCard extends StatelessWidget {
  final Kitchen kitchen;
  final VoidCallback onTap;

  const SubscribedKitchenCard({
    super.key,
    required this.kitchen,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            // Imagen cuadrada a la izquierda
            SizedBox(
              width: 100,
              height: 100,
              child: Image.network(
                kitchen.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (ctx, err, stack) => Container(
                  color: colors.surfaceVariant,
                  child: Icon(Icons.restaurant, color: colors.onSurfaceVariant),
                ),
              ),
            ),
            // Información a la derecha
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      kitchen.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      kitchen.description, // O ubicación si la tienes formateada
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.green.withOpacity(0.5)),
                      ),
                      child: Text(
                        'Suscrito',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: Colors.green[700],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 12.0),
              child: Icon(Icons.chevron_right),
            ),
          ],
        ),
      ),
    );
  }
}