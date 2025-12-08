import 'package:bienestar_integral_app/features/admin_home/presentation/providers/admin_events_provider.dart';
import 'package:bienestar_integral_app/features/admin_home/presentation/providers/admin_home_provider.dart';
import 'package:bienestar_integral_app/features/auth/presentation/widgets/custom_button.dart';
import 'package:bienestar_integral_app/features/events/presentation/widgets/success_dialog.dart';
import 'package:bienestar_integral_app/features/settings/presentation/widgets/home_app_bar.dart';
import 'package:bienestar_integral_app/shared/widgets/admin_text_field.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class LaunchEventScreen extends StatefulWidget {
  const LaunchEventScreen({super.key});

  @override
  State<LaunchEventScreen> createState() => _LaunchEventScreenState();
}

class _LaunchEventScreenState extends State<LaunchEventScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controladores
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _dateController = TextEditingController();
  final _startTimeController = TextEditingController();
  final _endTimeController = TextEditingController();
  final _capacityController = TextEditingController();
  final _dinersController = TextEditingController();

  DateTime? _selectedDate;

  // Cambiado a 'comida' por defecto ya que sabemos que funciona en Postman
  String _selectedEventType = 'comida';
  final List<String> _eventTypes = ['comida', 'especial', 'diario', 'emergencia'];

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    _capacityController.dispose();
    _dinersController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        // Formato requerido: YYYY-MM-DD
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _selectTime(bool isStart) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        // Formato requerido: HH:mm
        final formatted = '${picked.hour.toString().padLeft(2,'0')}:${picked.minute.toString().padLeft(2,'0')}';
        if (isStart) {
          _startTimeController.text = formatted;
        } else {
          _endTimeController.text = formatted;
        }
      });
    }
  }

  void _handleLaunchEvent() async {
    if (_formKey.currentState?.validate() ?? false) {

      // 1. Obtener ID de la cocina del usuario admin
      final adminHomeProvider = context.read<AdminHomeProvider>();
      final kitchenId = adminHomeProvider.kitchen?.id;

      if (kitchenId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error: No se ha identificado tu cocina. Reinicia la app o verifica tu conexión.')),
        );
        return;
      }

      // 2. Llamar al provider de eventos para crear
      final adminEventsProvider = context.read<AdminEventsProvider>();

      final success = await adminEventsProvider.launchEvent(
        kitchenId: kitchenId,
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        eventDate: _dateController.text,
        startTime: _startTimeController.text,
        endTime: _endTimeController.text,
        maxCapacity: int.tryParse(_capacityController.text) ?? 10,
        expectedDiners: int.tryParse(_dinersController.text) ?? 0,
        eventType: _selectedEventType,
        weatherCondition: 'Soleado', // Valor fijo para cumplir con el backend
      );

      if (mounted) {
        if (success) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => SuccessDialog(
              message: '¡Evento creado exitosamente!',
              onClose: () => context.pop(), // Regresa al home
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(adminEventsProvider.errorMessage ?? 'Error al crear evento'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final provider = context.watch<AdminEventsProvider>();

    return Scaffold(
      appBar: const HomeAppBar(title: 'Lanzar Evento', showBackButton: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Detalles del Nuevo Evento', style: textTheme.headlineMedium),
              const SizedBox(height: 24),

              AdminTextField(
                label: 'Nombre del evento',
                controller: _nameController,
                hint: 'Ej: Comida Navideña',
                validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
              ),
              const SizedBox(height: 16),

              // Dropdown Tipo de Evento
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Tipo de evento', style: textTheme.titleSmall?.copyWith(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _selectedEventType,
                    items: _eventTypes.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                    onChanged: (v) => setState(() => _selectedEventType = v!),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              AdminTextField(
                label: 'Descripción',
                controller: _descriptionController,
                hint: 'Detalles del evento...',
                maxLines: 3,
                validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
              ),
              const SizedBox(height: 16),

              AdminTextField(
                label: 'Fecha (YYYY-MM-DD)',
                controller: _dateController,
                readOnly: true,
                onTap: _selectDate,
                validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
                hint: 'Toca para seleccionar',
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: AdminTextField(
                      label: 'Inicio (HH:mm)',
                      controller: _startTimeController,
                      readOnly: true,
                      onTap: () => _selectTime(true),
                      validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AdminTextField(
                      label: 'Fin (HH:mm)',
                      controller: _endTimeController,
                      readOnly: true,
                      onTap: () => _selectTime(false),
                      validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: AdminTextField(
                      label: 'Capacidad (Voluntarios)',
                      controller: _capacityController,
                      keyboardType: TextInputType.number,
                      validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AdminTextField(
                      label: 'Comensales esperados',
                      controller: _dinersController,
                      keyboardType: TextInputType.number,
                      validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              CustomButton(
                text: 'Lanzar Evento',
                onPressed: _handleLaunchEvent,
                isLoading: provider.status == AdminEventStatus.loading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}