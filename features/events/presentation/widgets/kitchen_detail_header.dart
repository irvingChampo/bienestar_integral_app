import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class KitchenDetailHeader extends StatelessWidget {
  final String title;
  final String imageUrl;

  const KitchenDetailHeader({
    super.key,
    required this.title,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return SizedBox(
      height: 280, // Altura más generosa como en el HTML
      child: Stack(
        children: [
          // 1. Imagen de Fondo con Hero Animation
          Positioned.fill(
            child: Hero(
              tag: imageUrl, // Conexión visual con la pantalla anterior
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: colors.surfaceVariant,
                    child: Icon(Icons.restaurant, size: 50, color: colors.onSurfaceVariant),
                  );
                },
              ),
            ),
          ),

          // 2. Degradado oscuro para que el texto se lea (Overlay)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.8),
                  ],
                  stops: const [0.4, 0.7, 1.0],
                ),
              ),
            ),
          ),

          // 3. Botón de Regresar Flotante (Estilo circular)
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 16,
            child: InkWell(
              onTap: () => context.pop(),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2), // Efecto cristal
                  shape: BoxShape.circle,
                   // Opcional: Blur si quisieras
                ),
                child: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
              ),
            ),
          ),

          // 4. Título de la Cocina
          Positioned(
            bottom: 24,
            left: 20,
            right: 20,
            child: Text(
              title,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    offset: const Offset(0, 2),
                    blurRadius: 4,
                    color: Colors.black.withOpacity(0.5),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}