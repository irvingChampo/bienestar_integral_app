import 'package:bienestar_integral_app/features/auth/presentation/widgets/custom_button.dart';
import 'package:bienestar_integral_app/features/events/presentation/widgets/success_dialog.dart';
import 'package:bienestar_integral_app/features/settings/presentation/widgets/home_app_bar.dart';
import 'package:bienestar_integral_app/shared/widgets/admin_text_field.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LaunchEventScreen extends StatefulWidget {
  const LaunchEventScreen({super.key});

  @override
  State<LaunchEventScreen> createState() => _LaunchEventScreenState();
}

class _LaunchEventScreenState extends State<LaunchEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _placeController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _placeController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _descriptionController.dispose();
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
      _dateController.text = "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
    }
  }

  Future<void> _selectTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      _timeController.text = picked.format(context);
    }
  }

  void _handleLaunchEvent() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);

      // Simular llamada a la API
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() => _isLoading = false);
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => SuccessDialog(
              message: '¡El evento ha sido lanzado exitosamente!',
              onClose: () => context.pop(), // Vuelve a la pantalla anterior (admin home)
            ),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
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
              const SizedBox(height: 32),

              AdminTextField(
                label: 'Nombre del evento',
                controller: _nameController,
                hint: 'Ej: Donación navideña',
                validator: (v) => v == null || v.isEmpty ? 'Ingresa el nombre del evento' : null,
              ),
              const SizedBox(height: 20),

              AdminTextField(
                label: 'Lugar',
                controller: _placeController,
                hint: 'Ej: Calzada al sumidero',
                validator: (v) => v == null || v.isEmpty ? 'Ingresa el lugar' : null,
              ),
              const SizedBox(height: 20),

              AdminTextField(
                label: 'Fecha',
                controller: _dateController,
                hint: 'Selecciona una fecha',
                readOnly: true,
                onTap: _selectDate,
                validator: (v) => v == null || v.isEmpty ? 'Selecciona una fecha' : null,
              ),
              const SizedBox(height: 20),

              AdminTextField(
                label: 'Hora',
                controller: _timeController,
                hint: 'Selecciona una hora',
                readOnly: true,
                onTap: _selectTime,
                validator: (v) => v == null || v.isEmpty ? 'Selecciona una hora' : null,
              ),
              const SizedBox(height: 20),

              AdminTextField(
                label: 'Descripción',
                controller: _descriptionController,
                hint: 'Describe los detalles del evento...',
                maxLines: 5,
                validator: (v) => v == null || v.isEmpty ? 'Ingresa una descripción' : null,
              ),
              const SizedBox(height: 32),

              CustomButton(
                text: 'Lanzar Evento',
                onPressed: _handleLaunchEvent,
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
