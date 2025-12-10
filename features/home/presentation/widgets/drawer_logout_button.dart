import 'package:flutter/material.dart';

class DrawerLogoutButton extends StatelessWidget {
  final VoidCallback onTap;

  const DrawerLogoutButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: colors.outline.withOpacity(0.1)),
        ),
      ),
      // CAMBIO: Usamos Material widget para el color de fondo.
      // Esto permite que el InkWell pinte el efecto "hover" sobre el rojo.
      child: Material(
        color: colors.error, // Rojo base
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),

          // --- CONFIGURACIÓN DE COLORES DE INTERACCIÓN ---
          // Color cuando el cursor pasa por encima (Hover)
          hoverColor: Colors.red.shade900,
          // Color cuando se presiona (Splash/Highlight)
          splashColor: Colors.white.withOpacity(0.2),
          highlightColor: Colors.white.withOpacity(0.1),

          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            // Nota: Ya no ponemos 'decoration' aquí para no tapar el efecto del InkWell
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.logout, color: Colors.white, size: 20),
                SizedBox(width: 12),
                Text(
                  'Cerrar sesión',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}