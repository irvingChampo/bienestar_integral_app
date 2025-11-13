import 'package:bienestar_integral_app/features/manage_volunteers/presentation/widgets/assign_role_dialog.dart';
import 'package:bienestar_integral_app/features/manage_volunteers/presentation/widgets/event_info_section.dart';
import 'package:bienestar_integral_app/features/manage_volunteers/presentation/widgets/volunteer_item_card.dart';
import 'package:bienestar_integral_app/features/settings/presentation/widgets/home_app_bar.dart';
import 'package:flutter/material.dart';

class ManageVolunteersScreen extends StatefulWidget {
  const ManageVolunteersScreen({super.key});

  @override
  State<ManageVolunteersScreen> createState() => _ManageVolunteersScreenState();
}

class _ManageVolunteersScreenState extends State<ManageVolunteersScreen> {
  final List<Map<String, dynamic>> _volunteers = [
    {'name': 'Didier Mendoza', 'reputation': 4.8, 'avatarUrl': ''},
    {'name': 'Irving Champo', 'reputation': 5.0, 'avatarUrl': ''},
    {'name': 'Brandon Gómez', 'reputation': 2.8, 'avatarUrl': ''},
    {'name': 'Margarita Olivera', 'reputation': 4.9, 'avatarUrl': ''},
  ];

  void _handleViewProfile(String name) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Viendo perfil de $name')),
    );
  }

  void _handleAssignRole(String name) async {
    final selectedRole = await showDialog<String>(
      context: context,
      builder: (context) => AssignRoleDialog(volunteerName: name),
    );

    if (selectedRole != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$name fue asignado como $selectedRole')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppBar(title: 'Gestión de Voluntarios', showBackButton: true),
      body: ListView(
        children: [
          // Widget con la información del evento
          const EventInfoSection(
            description: 'Este evento va dirigido a personas indigentes por las fechas navideñas.',
            dayName: 'Domingo',
            dayNumber: '03',
            monthYear: 'Oct/2026',
            startTime: '02:30 pm',
            endTime: '5:00 pm',
            location: 'Calzada al sumidero, enfrente de Bodega Aurrera.',
            coordinators: 2,
            volunteers: 13,
          ),
          const SizedBox(height: 8),

          // Lista de voluntarios
          ..._volunteers.map((volunteer) => VolunteerItemCard(
            name: volunteer['name'],
            reputation: volunteer['reputation'],
            avatarUrl: volunteer['avatarUrl'],
            onViewProfile: () => _handleViewProfile(volunteer['name']),
            onAssignRole: () => _handleAssignRole(volunteer['name']),
          )).toList(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}