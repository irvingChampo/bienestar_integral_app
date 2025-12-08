import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final PreferredSizeWidget? bottom;
  final List<Widget>? actions;

  const HomeAppBar({
    super.key,
    required this.title,
    this.showBackButton = false,
    this.bottom,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return AppBar(
      // 1. Fondo transparente para que se vea el degradado
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,

      // 2. Forzamos iconos y texto a color NEGRO (onPrimary) siempre,
      // porque el fondo siempre será amarillo degradado.
      iconTheme: IconThemeData(color: colors.onPrimary),
      titleTextStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
        color: colors.onPrimary,
        fontWeight: FontWeight.bold,
      ),

      // 3. AQUÍ ESTÁ EL DEGRADADO
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colors.primary,          // Amarillo fuerte
              colors.primaryContainer, // Amarillo suave
            ],
          ),
        ),
      ),

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
      actions: actions,
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
      kToolbarHeight + (bottom?.preferredSize.height ?? 0.0));
}