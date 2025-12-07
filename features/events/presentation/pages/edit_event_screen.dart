import 'package:bienestar_integral_app/features/admin_home/presentation/providers/admin_events_provider.dart';
import 'package:bienestar_integral_app/features/auth/presentation/widgets/custom_button.dart';
import 'package:bienestar_integral_app/features/events/domain/entities/event.dart';
import 'package:bienestar_integral_app/features/events/presentation/widgets/success_dialog.dart';
import 'package:bienestar_integral_app/features/settings/presentation/widgets/home_app_bar.dart';
import 'package:bienestar_integral_app/shared/widgets/admin_text_field.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class EditEventScreen extends StatefulWidget {
  final Event event;

  const EditEventScreen({super.key, required this.event});

  @override
  State<EditEventScreen> createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<EditEventScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _dateController;
  late TextEditingController _startTimeController;
  late TextEditingController _endTimeController;
  late TextEditingController _capacityController;
  late TextEditingController _dinersController;

  late String _selectedEventType;
  final List<String> _eventTypes = ['comida', 'especial', 'diario', 'emergencia'];

  @override
  void initState() {
    super.initState();
    // Pre-llenar datos
    _nameController = TextEditingController(text: widget.event.name);
    _descriptionController = TextEditingController(text: widget.event.description);
    _dateController = TextEditingController(text: widget.event.eventDate);
    _startTimeController = TextEditingController(text: widget.event.startTime);
    _endTimeController = TextEditingController(text: widget.event.endTime);
    _capacityController = TextEditingController(text: widget.event.maxCapacity.toString());
    _dinersController = TextEditingController(text: (widget.event.expectedDiners ?? 0).toString());

    // Validar que el tipo exista en la lista, si no, usar el primero
    _selectedEventType = widget.event.eventType ?? 'comida';
    if (!_eventTypes.contains(_selectedEventType)) {
      _selectedEventType = 'comida';
    }
  }

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
    DateTime initialDate = DateTime.now();
    try {
      initialDate = DateFormat('yyyy-MM-dd').parse(_dateController.text);
    } catch (_) {}

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _selectTime(bool isStart) async {
    // Parsear hora actual del texto para el picker
    TimeOfDay initialTime = TimeOfDay.now();
    try {
      final text = isStart ? _startTimeController.text : _endTimeController.text;
      final parts = text.split(':');
      if (parts.length == 2) {
        initialTime = TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
      }
    } catch (_) {}

    final picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (picked != null) {
      setState(() {
        final formatted = '${picked.hour.toString().padLeft(2,'0')}:${picked.minute.toString().padLeft(2,'0')}';
        if (isStart) {
          _startTimeController.text = formatted;
        } else {
          _endTimeController.text = formatted;
        }
      });
    }
  }

  void _handleEditEvent() async {
    if (_formKey.currentState?.validate() ?? false) {
      final adminEventsProvider = context.read<AdminEventsProvider>();

      final success = await adminEventsProvider.editEvent(
        eventId: widget.event.id,
        kitchenId: widget.event.kitchenId,
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        eventDate: _dateController.text,
        startTime: _startTimeController.text,
        endTime: _endTimeController.text,
        maxCapacity: int.tryParse(_capacityController.text) ?? 0,
        expectedDiners: int.tryParse(_dinersController.text) ?? 0,
        eventType: _selectedEventType,
      );

      if (mounted) {
        if (success) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => SuccessDialog(
              message: '¡Evento actualizado!',
              onClose: () {
                context.pop(); // Cierra Dialog
                context.pop(); // Regresa al detalle
                context.pop(); // Regresa al home (para refrescar)
                // O usa context.go(AppRoutes.adminHomePath) para forzar recarga
              },
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(adminEventsProvider.errorMessage ?? 'Error al actualizar'),
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
      appBar: const HomeAppBar(title: 'Editar Evento', showBackButton: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AdminTextField(
                label: 'Nombre del evento',
                controller: _nameController,
                validator: (v) => v!.isEmpty ? 'Requerido' : null,
              ),
              const SizedBox(height: 16),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Tipo de evento', style: textTheme.titleSmall),
                  DropdownButtonFormField<String>(
                    value: _selectedEventType,
                    items: _eventTypes.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                    onChanged: (v) => setState(() => _selectedEventType = v!),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              AdminTextField(
                label: 'Descripción',
                controller: _descriptionController,
                maxLines: 3,
                validator: (v) => v!.isEmpty ? 'Requerido' : null,
              ),
              const SizedBox(height: 16),

              AdminTextField(
                label: 'Fecha',
                controller: _dateController,
                readOnly: true,
                onTap: _selectDate,
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: AdminTextField(
                      label: 'Inicio',
                      controller: _startTimeController,
                      readOnly: true,
                      onTap: () => _selectTime(true),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AdminTextField(
                      label: 'Fin',
                      controller: _endTimeController,
                      readOnly: true,
                      onTap: () => _selectTime(false),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: AdminTextField(
                      label: 'Capacidad',
                      controller: _capacityController,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AdminTextField(
                      label: 'Comensales',
                      controller: _dinersController,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              CustomButton(
                text: 'Guardar Cambios',
                onPressed: _handleEditEvent,
                isLoading: provider.status == AdminEventStatus.loading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}