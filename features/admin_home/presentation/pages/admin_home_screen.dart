import 'package:bienestar_integral_app/core/router/routes.dart';
import 'package:bienestar_integral_app/features/admin_home/presentation/widgets/admin_bottom_bar.dart';
import 'package:bienestar_integral_app/features/admin_home/presentation/widgets/admin_header.dart';
import 'package:bienestar_integral_app/features/admin_home/presentation/widgets/event_card_admin.dart';
import 'package:bienestar_integral_app/features/admin_home/presentation/widgets/kitchen_info_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  // Datos de ejemplo
  final Map<String, String> _schedule = {
    'Lunes': '5:30 a.m. – 5:00 p.m.',
    'Martes': '5:30 a.m. – 5:00 p.m.',
    'Miércoles': '5:30 a.m. – 5:00 p.m.',
    'Jueves': '5:30 a.m. – 5:00 p.m.',
    'Viernes': '5:30 a.m. – 5:00 p.m.',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const AdminHeader(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  KitchenInfoCard(
                    title: 'Cocina Integral',
                    subtitle: 'Calzada al Sumidero, Tuxtla Gtz.',
                    ownerName: 'Irving Champo',
                    imageUrl: 'https://images.unsplash.com/photo-1556911220-e15b29be8c8f?w=800',
                    schedule: _schedule,
                  ),
                  const SizedBox(height: 8),
                  const EventCardAdmin(
                    eventNumber: '1',
                    description: 'Evento de donación de alimentos para familias necesitadas. Se requiere apoyo de voluntarios para la distribución.',
                    date: '24/12/2025',
                    currentCount: '0',
                    maxCount: '20',
                  ),
                  const SizedBox(height: 100), // Espacio para el bottom bar
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: AdminBottomBar(
        onLaunchEvent: () => context.push(AppRoutes.launchEventPath),
        onManageUsers: () => context.push(AppRoutes.manageVolunteersPath),
        onAddProduct: () => context.push(AppRoutes.addProductPath),
      ),
    );
  }
}