// features/home/presentation/widgets/kitchen_card.dart (NUEVO)
import 'package:bienestar_integral_app/features/home/domain/entities/kitchen.dart';
import 'package:flutter/material.dart';

class KitchenCard extends StatelessWidget {
  final Kitchen kitchen;
  final VoidCallback onTap;

  const KitchenCard({
    super.key,
    required this.kitchen,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        height: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: colors.shadow.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.network(
                  kitchen.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: colors.surfaceVariant,
                      child: Icon(Icons.image_not_supported, size: 50, color: colors.onSurfaceVariant),
                    );
                  },
                ),
              ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, colors.shadow.withOpacity(0.8)],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: colors.surface.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(Icons.restaurant, size: 20, color: colors.primary),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            kitchen.name,
                            style: textTheme.titleMedium?.copyWith(
                              color: colors.onInverseSurface,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 16, color: colors.onInverseSurface),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            kitchen.description, // Usamos la descripción como subtítulo
                            style: textTheme.bodySmall?.copyWith(color: colors.onInverseSurface),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}