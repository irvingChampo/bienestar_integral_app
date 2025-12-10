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
      // --- CAMBIO VISUAL: Color sólido uniforme ---
      // Antes era Colors.transparent y se usaba flexibleSpace con degradado.
      // Ahora usamos directamente el color primario (Amarillo).
      backgroundColor: colors.primary,

      elevation: 0,
      centerTitle: true,

      // Forzamos iconos y texto a color definido en onPrimary (generalmente Negro sobre Amarillo)
      iconTheme: IconThemeData(color: colors.onPrimary),
      titleTextStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
        color: colors.onPrimary,
        fontWeight: FontWeight.bold,
      ),

      // --- CAMBIO VISUAL: Se eliminó la sección flexibleSpace que contenía el degradado ---

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