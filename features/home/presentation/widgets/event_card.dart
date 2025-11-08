import 'package:flutter/material.dart';

class EventCard extends StatelessWidget {
  final String title;
  final String location;
  final String imageUrl;
  final VoidCallback onTap;

  const EventCard({
    super.key,
    required this.title,
    required this.location,
    required this.imageUrl,
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
              // CAMBIO: Se usa el color `shadow` del tema.
              color: colors.shadow.withOpacity(0.1), // ANTES: Colors.black.withOpacity(0.1)
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
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      // CAMBIO: Se usan colores del tema.
                      color: colors.surfaceVariant, // ANTES: Colors.grey.shade300
                      child: Icon(Icons.image_not_supported, size: 50, color: colors.onSurfaceVariant), // ANTES: Colors.grey
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
                      // CAMBIO: Se usa el color `shadow` del tema.
                      colors: [Colors.transparent, colors.shadow.withOpacity(0.8)], // ANTES: Colors.black...
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
                            // CAMBIO: Se usa el color `surface` del tema.
                            color: colors.surface.withOpacity(0.9), // ANTES: Colors.white.withOpacity(0.9)
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(Icons.restaurant, size: 20, color: colors.primary),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            title,
                            style: textTheme.titleMedium?.copyWith(
                              // CAMBIO: Se usa un color apropiado para texto sobre fondos oscuros.
                              color: colors.onInverseSurface, // ANTES: Colors.white
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
                        Icon(Icons.location_on, size: 16, color: colors.onInverseSurface), // ANTES: color: Colors.white
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            location,
                            style: textTheme.bodySmall?.copyWith(color: colors.onInverseSurface), // ANTES: color: Colors.white
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