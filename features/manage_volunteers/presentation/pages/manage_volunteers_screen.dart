import 'package:bienestar_integral_app/features/admin_home/presentation/providers/admin_events_provider.dart';
import 'package:bienestar_integral_app/features/events/domain/entities/event.dart';
import 'package:bienestar_integral_app/features/manage_volunteers/presentation/widgets/event_info_section.dart';
import 'package:bienestar_integral_app/features/manage_volunteers/presentation/widgets/volunteer_item_card.dart';
import 'package:bienestar_integral_app/features/settings/presentation/widgets/home_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ManageVolunteersScreen extends StatefulWidget {
  const ManageVolunteersScreen({super.key});

  @override
  State<ManageVolunteersScreen> createState() => _ManageVolunteersScreenState();
}

class _ManageVolunteersScreenState extends State<ManageVolunteersScreen> {
  Event? _event;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final extra = GoRouterState.of(context).extra;

      if (extra is Event) {
        setState(() {
          _event = extra;
        });
        // Llama al endpoint que acabamos de configurar
        context.read<AdminEventsProvider>().loadEventParticipants(_event!.id);
      }
    });
  }

  String _capitalize(String? text) {
    if (text == null || text.isEmpty) return 'General';
    return text[0].toUpperCase() + text.substring(1);
  }

  // Helpers manuales de fecha (para evitar dependencias de locale)
  String _translateDay(String day) {
    const days = {
      'Monday': 'Lunes', 'Tuesday': 'Martes', 'Wednesday': 'Miércoles',
      'Thursday': 'Jueves', 'Friday': 'Viernes', 'Saturday': 'Sábado', 'Sunday': 'Domingo'
    };
    return days[day] ?? day;
  }

  String _translateMonth(String month) {
    const months = {
      'Jan': 'Ene', 'Feb': 'Feb', 'Mar': 'Mar', 'Apr': 'Abr', 'May': 'May', 'Jun': 'Jun',
      'Jul': 'Jul', 'Aug': 'Ago', 'Sep': 'Sep', 'Oct': 'Oct', 'Nov': 'Nov', 'Dec': 'Dic'
    };
    return months[month] ?? month;
  }

  Map<String, String> _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      final dayNameEn = DateFormat('EEEE').format(date);
      final monthEn = DateFormat('MMM').format(date);

      return {
        'dayName': _translateDay(dayNameEn),
        'dayNumber': DateFormat('dd').format(date),
        'monthYear': '${_translateMonth(monthEn)}/${date.year}',
      };
    } catch (e) {
      return {'dayName': '-', 'dayNumber': '-', 'monthYear': '-'};
    }
  }

  void _showParticipantDetails(BuildContext context, String email, String? phone) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Información de contacto"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: const Icon(Icons.email),
              title: Text(email),
              subtitle: const Text("Correo electrónico"),
            ),
            ListTile(
              leading: const Icon(Icons.phone),
              title: Text(phone ?? "No registrado"),
              subtitle: const Text("Teléfono"),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cerrar"))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AdminEventsProvider>();
    final participants = provider.participants;

    if (_event == null) {
      return const Scaffold(
        appBar: HomeAppBar(title: 'Cargando...', showBackButton: true),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final dateInfo = _formatDate(_event!.eventDate);
    final String detailsInfo =
        'Tipo: ${_capitalize(_event!.eventType)}\n'
        'Comensales esperados: ${_event!.expectedDiners ?? 0}';

    return Scaffold(
      appBar: HomeAppBar(title: 'Voluntarios: ${_event!.name}', showBackButton: true),
      body: RefreshIndicator(
        onRefresh: () async => await provider.loadEventParticipants(_event!.id),
        child: ListView(
          padding: const EdgeInsets.only(bottom: 40),
          children: [
            // Cabecera con info del evento
            EventInfoSection(
              description: _event!.description,
              dayName: dateInfo['dayName']!,
              dayNumber: dateInfo['dayNumber']!,
              monthYear: dateInfo['monthYear']!,
              startTime: _event!.startTime,
              endTime: _event!.endTime,
              location: detailsInfo,
              coordinators: 0,
              volunteers: _event!.maxCapacity,
            ),

            const Padding(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Lista de Inscritos',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  // Opcional: Mostrar contador
                  // Text('${participants.length} inscritos', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),

            if (provider.status == AdminEventStatus.loading)
              const Padding(
                padding: EdgeInsets.all(32.0),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (participants.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Text(
                    'Aún no hay voluntarios inscritos en este evento.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              )
            else
            // Renderizado de la lista usando datos del JSON
              ...participants.map((participant) => VolunteerItemCard(
                name: participant.fullName, // Nombres + Apellido
                reputation: 5.0, // Dummy (El JSON no trae reputación)
                avatarUrl: '', // Dummy (El JSON no trae avatar)
                onViewProfile: () {
                  // Mostramos los datos reales del JSON (email y teléfono)
                  _showParticipantDetails(context, participant.email, participant.phoneNumber);
                },
                onAssignRole: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Asignar rol a ${participant.names} (Próximamente)'))
                  );
                },
              )).toList(),
          ],
        ),
      ),
    );
  }
}