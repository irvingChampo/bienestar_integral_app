import 'package:flutter/material.dart';

class DrawerMenuItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;
  final int? badgeCount; // Opcional: Si es null o 0, no se muestra

  const DrawerMenuItem({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
    this.badgeCount,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: colors.primary.withOpacity(0.1),
        highlightColor: colors.primary.withOpacity(0.05),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: const BoxDecoration(
            border: Border(
              left: BorderSide(color: Colors.transparent, width: 4),
            ),
          ),
          child: Row(
            children: [
              Icon(icon, color: colors.primary, size: 24),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  text,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ),
              // Lógica de visualización: Solo muestra el badge si hay número > 0
              if (badgeCount != null && badgeCount! > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: colors.error,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    badgeCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}