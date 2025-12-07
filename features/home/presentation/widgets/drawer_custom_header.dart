import 'package:flutter/material.dart';

class DrawerCustomHeader extends StatelessWidget {
  const DrawerCustomHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return SizedBox(
      height: 220,
      child: Stack(
        children: [
          // Fondo con degradado usando tu semilla de color
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  colors.primary, // Amarillo principal
                  colors.primaryContainer, // Tono complementario
                ],
              ),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(30),
              ),
            ),
          ),
          // Círculo decorativo (Efecto visual)
          Positioned(
            top: -50,
            right: -50,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.2),
              ),
            ),
          ),
          // Contenido: Icono y Texto
          Positioned(
            bottom: 30,
            left: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icono circular negro
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.person,
                    size: 35,
                    color: colors.primary, // Icono amarillo
                  ),
                ),
                const SizedBox(height: 15),
                // Nombre de la App
                const Text(
                  'Bienestar Integral',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
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