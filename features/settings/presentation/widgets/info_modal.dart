import 'dart:ui'; // Necesario para ImageFilter
import 'package:flutter/material.dart';

class InfoModal extends StatelessWidget {
  final String title;
  final Widget content;

  const InfoModal({
    super.key,
    required this.title,
    required this.content,
  });

  // Método estático para mostrar el modal fácilmente desde cualquier lado
  static void show(BuildContext context, {required String title, required Widget content}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Permite altura personalizada
      backgroundColor: Colors.transparent, // Transparente para que se vea el blur
      barrierColor: Colors.black.withOpacity(0.5), // Oscurecimiento del 50%
      transitionAnimationController: AnimationController(
        vsync: Navigator.of(context),
        duration: const Duration(milliseconds: 400), // Duración del deslizamiento
      ),
      builder: (context) => InfoModal(title: title, content: content),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
        // 1. Efecto Blur (Desenfoque) en el fondo
        Positioned.fill(
          child: GestureDetector(
            onTap: () => Navigator.pop(context), // Cerrar al tocar fuera
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4), // Blur de 4px
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
        ),

        // 2. El Modal en sí
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: size.height * 0.85, // 85% de la altura
            width: double.infinity,
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            // Usamos Column para dejar el Header Fijo y el Body con Scroll
            child: Column(
              children: [
                // --- ENCABEZADO FIJO (Sticky) ---
                _ModalHeader(title: title),

                const Divider(height: 1),

                // --- CONTENIDO CON SCROLL ---
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: content,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// Widget privado para el botón de cierre animado
class _ModalHeader extends StatefulWidget {
  final String title;
  const _ModalHeader({required this.title});

  @override
  State<_ModalHeader> createState() => _ModalHeaderState();
}

class _ModalHeaderState extends State<_ModalHeader> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Titulo con el subrayado amarillo (decoración)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                width: 40,
                height: 3,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary, // Amarillo
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),

          // Botón X con animación de rotación
          GestureDetector(
            onTapDown: (_) => setState(() => _isHovered = true),
            onTapUp: (_) {
              setState(() => _isHovered = false);
              Navigator.pop(context);
            },
            onTapCancel: () => setState(() => _isHovered = false),
            child: AnimatedRotation(
              turns: _isHovered ? 0.25 : 0.0, // Gira 90 grados (0.25 de vuelta)
              duration: const Duration(milliseconds: 200),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.close,
                  size: 20,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}