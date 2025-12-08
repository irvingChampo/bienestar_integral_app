// features/home/presentation/pages/home_screen.dart (MODIFICADO)

import 'package:bienestar_integral_app/core/router/routes.dart';
import 'package:bienestar_integral_app/features/home/domain/entities/kitchen.dart';
import 'package:bienestar_integral_app/features/home/presentation/providers/home_provider.dart';
import 'package:bienestar_integral_app/features/home/presentation/widgets/custom_drawer.dart';
import 'package:bienestar_integral_app/features/home/presentation/widgets/kitchen_card.dart';
import 'package:bienestar_integral_app/features/settings/presentation/widgets/home_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Llamamos a la carga de datos cuando el widget se inicializa
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeProvider>().fetchNearbyKitchens();
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final homeProvider = context.watch<HomeProvider>();

    return Scaffold(
      appBar: const HomeAppBar(title: 'Bienestar Integral'),
      drawer: const CustomDrawer(),
      body: RefreshIndicator(
        onRefresh: () async => await context.read<HomeProvider>().fetchNearbyKitchens(),
        color: Theme.of(context).colorScheme.primary,
        child: _buildBody(homeProvider, textTheme),
      ),
    );
  }

  Widget _buildBody(HomeProvider provider, TextTheme textTheme) {
    switch (provider.status) {
      case HomeStatus.loading:
        return const Center(child: CircularProgressIndicator());
      case HomeStatus.error:
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              provider.errorMessage ?? 'Ocurrió un error',
              textAlign: TextAlign.center,
            ),
          ),
        );
      case HomeStatus.initial:
      case HomeStatus.success:
        if (provider.kitchens.isEmpty) {
          return const Center(child: Text('No se encontraron cocinas cercanas.'));
        }
        return ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Cocinas Disponibles', style: textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  Text('Aportar te da vida', style: textTheme.bodyLarge),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ...provider.kitchens.map((kitchen) {
              return KitchenCard(
                kitchen: kitchen,
                onTap: () => _showKitchenDetails(context, kitchen),
              );
            }).toList(),
          ],
        );
    }
  }

  void _showKitchenDetails(BuildContext context, Kitchen kitchen) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.restaurant, color: colorScheme.onPrimary),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(kitchen.name, style: textTheme.titleLarge),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text('Descripción', style: textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(
                kitchen.description,
                style: textTheme.bodyMedium?.copyWith(height: 1.4),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cerrar'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        // Pasamos el ID de la cocina a la siguiente pantalla
                        context.push(
                          '${AppRoutes.eventDetailsPath}/${kitchen.id}',
                          extra: kitchen.toDisplayData(), // Enviamos datos básicos para mostrar mientras cargan los detalles
                        );
                      },
                      child: const Text('Ver más'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}