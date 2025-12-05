import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final PreferredSizeWidget? bottom; // <-- NUEVA PROPIEDAD

  const HomeAppBar({
    super.key,
    required this.title,
    this.showBackButton = false,
    this.bottom, // <-- AGREGAR AL CONSTRUCTOR
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: showBackButton
          ? IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => context.pop(),
      )
          : Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
      title: Text(title),
      bottom: bottom, // <-- ASIGNAR AQUÍ
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
      kToolbarHeight + (bottom?.preferredSize.height ?? 0.0)); // <-- CALCULAR ALTURA DINÁMICA
}