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
              // 1. IMAGEN DE FONDO
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
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.8) // Sombra negra siempre
                      ],
                    ),
                  ),
                ),
              ),

              // 3. CONTENIDO (Texto e Iconos)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        // Cajita del icono (tenedor/cuchillo)
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            // En modo oscuro se verá oscura, en claro blanca.
                            // Esto está bien para la cajita.
                            color: colors.surface.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(Icons.restaurant, size: 20, color: colors.primary),
                        ),
                        const SizedBox(width: 12),

                        // TÍTULO DE LA COCINA
                        Expanded(
                          child: Text(
                            kitchen.name,
                            style: textTheme.titleMedium?.copyWith(
                              // CORRECCIÓN: SIEMPRE BLANCO
                              // (porque está sobre fondo oscuro/imagen)
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  const Shadow(blurRadius: 4, color: Colors.black, offset: Offset(0, 1))
                                ]
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // UBICACIÓN / DESCRIPCIÓN
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 16, color: Colors.white70), // Icono blanco
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            kitchen.description,
                            style: textTheme.bodySmall?.copyWith(
                              // CORRECCIÓN: SIEMPRE BLANCO
                              color: Colors.white,
                            ),
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