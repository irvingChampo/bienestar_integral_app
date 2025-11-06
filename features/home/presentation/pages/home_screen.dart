import 'package:bienestar_integral_app/core/router/routes.dart';
import 'package:bienestar_integral_app/features/home/presentation/widgets/custom_drawer.dart';
import 'package:bienestar_integral_app/features/home/presentation/widgets/event_card.dart';
import 'package:bienestar_integral_app/features/settings/presentation/widgets/home_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Datos de ejemplo
  final List<Map<String, String>> _events = [
    {'title': 'Margarita Olivera', 'location': 'Sda poniente norte', 'image': 'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?w=800'},
    {'title': 'Cocina Champo', 'location': 'Sda poniente norte', 'image': 'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=800'},
    {'title': 'Cocina Alegría', 'location': 'Colonia centro', 'image': 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=800'},
    {'title': 'Sopas del Corazón', 'location': 'Terán', 'image': 'https://images.unsplash.com/photo-1490645935967-10de6ba17061?w=800'},
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: const HomeAppBar(title: 'Bienestar Integral'),
      drawer: const CustomDrawer(),
      body: RefreshIndicator(
        onRefresh: () async => await Future.delayed(const Duration(seconds: 1)),
        color: colorScheme.primary,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Eventos disponibles', style: textTheme.headlineSmall?.copyWith(color: Colors.black)),
                  const SizedBox(height: 8),
                  Text('Aportar te da vida', style: textTheme.bodyLarge?.copyWith(color: Colors.black.withOpacity(0.8))),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Lista de eventos
            ..._events.map((event) {
              return EventCard(
                title: event['title']!,
                location: event['location']!,
                imageUrl: event['image']!,
                onTap: () => _showEventDetails(context, event),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  void _showEventDetails(BuildContext context, Map<String, String> event) {
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
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFD700), // Amarillo
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.restaurant, color: Colors.black),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(event['title']!, style: textTheme.titleLarge),
                        const SizedBox(height: 4),
                        Text(event['location']!, style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Descripción
              Text('Descripción', style: textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(
                'Se busca personal para evento de cocina. Experiencia preferible pero no necesaria.',
                style: textTheme.bodyMedium?.copyWith(height: 1.4),
              ),
              const SizedBox(height: 24),

              // Botones
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
                        context.push(AppRoutes.eventDetailsPath, extra: event);
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