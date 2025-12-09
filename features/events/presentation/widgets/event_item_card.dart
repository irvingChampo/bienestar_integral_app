import 'package:flutter/material.dart';

class KitchenInfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const KitchenInfoItem({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        // Fondo: En oscuro un gris un poco más claro que el negro de fondo.
        // En claro, blanco.
        color: isDark ? colors.surfaceVariant.withOpacity(0.2) : colors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          if (!isDark) // Solo sombra en modo claro
            BoxShadow(
              color: colors.shadow.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
        ],
        border: Border(
          left: BorderSide(color: colors.primary, width: 4),
          // Borde sutil alrededor en modo oscuro para definir la tarjeta
          top: isDark ? BorderSide(color: colors.outline.withOpacity(0.2)) : BorderSide.none,
          right: isDark ? BorderSide(color: colors.outline.withOpacity(0.2)) : BorderSide.none,
          bottom: isDark ? BorderSide(color: colors.outline.withOpacity(0.2)) : BorderSide.none,
        ),
      ),
      child: Row(
        children: [
          // Icono con fondo degradado
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  colors.primary,
                  // En modo oscuro usamos el mismo primary para evitar que se vea "sucio"
                  // En modo claro usamos primaryContainer
                  isDark ? colors.primary.withOpacity(0.8) : colors.primaryContainer,
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            // El icono SIEMPRE negro/oscuro porque el fondo es amarillo
            child: Icon(icon, color: Colors.black87, size: 24),
          ),
          const SizedBox(width: 16),
          // Textos
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label.toUpperCase(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    // En modo oscuro usamos un gris claro, en claro un gris oscuro
                    color: isDark ? colors.onSurfaceVariant : colors.onSurfaceVariant,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    // En modo oscuro blanco, en claro negro
                    color: colors.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}