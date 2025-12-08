// features/register/presentation/pages/register_step3_screen.dart (CÓDIGO COMPLETO Y CORREGIDO)

import 'package:bienestar_integral_app/core/router/routes.dart';
import 'package:bienestar_integral_app/features/auth/presentation/widgets/custom_button.dart';
import 'package:bienestar_integral_app/features/register/presentation/providers/register_provider.dart';
import 'package:bienestar_integral_app/features/register/presentation/widgets/availability_day_card.dart';
import 'package:bienestar_integral_app/features/register/presentation/widgets/back_button_custom.dart';
import 'package:bienestar_integral_app/features/register/presentation/widgets/custom_checkbox.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class RegisterStep3Screen extends StatefulWidget {
  const RegisterStep3Screen({super.key});
  @override
  State<RegisterStep3Screen> createState() => _RegisterStep3ScreenState();
}

class _RegisterStep3ScreenState extends State<RegisterStep3Screen> {
  final Map<int, bool> _selectedSkills = {};
  final Map<String, TimeOfDay?> _startTimes = {};
  final Map<String, TimeOfDay?> _endTimes = {};
  final Map<String, bool> _daysSelected = {
    'Lunes': false, 'Martes': false, 'Miércoles': false, 'Jueves': false, 'Viernes': false, 'Sábado': false, 'Domingo': false
  };
  final List<String> _dayOrder = ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'];

  // --- MÉTODO _handleFinalize ACTUALIZADO CON VALIDACIONES COMPLETAS ---
  void _handleFinalize() {
    FocusManager.instance.primaryFocus?.unfocus();

    // 1. Validar las reglas de negocio (habilidades y horarios)
    final businessRuleError = _validateBusinessRules();
    if (businessRuleError != null) {
      _showErrorSnackBar(businessRuleError);
      return;
    }

    // 2. Si todo es válido, guardar los datos y enviar
    final selectedSkillIds = _selectedSkills.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();

    final registerProvider = context.read<RegisterProvider>();
    registerProvider.saveStep3Data({
      'skillIds': selectedSkillIds,
      'availability': _daysSelected,
      'startTimes': _startTimes,
      'endTimes': _endTimes,
    });

    registerProvider.submitRegistration();
  }

  // --- NUEVO MÉTODO PARA VALIDAR HABILIDADES Y DISPONIBILIDAD ---
  String? _validateBusinessRules() {
    // Validar que al menos una habilidad esté seleccionada
    if (!_selectedSkills.containsValue(true)) {
      return 'Debes seleccionar al menos una habilidad.';
    }

    // Validar que los horarios seleccionados sean coherentes
    for (final day in _dayOrder) {
      if (_daysSelected[day] ?? false) {
        final start = _startTimes[day];
        final end = _endTimes[day];
        if (start == null || end == null) {
          return 'Debes seleccionar hora de inicio y fin para $day.';
        }

        final startTimeInMinutes = start.hour * 60 + start.minute;
        final endTimeInMinutes = end.hour * 60 + end.minute;

        if (startTimeInMinutes >= endTimeInMinutes) {
          return 'La hora de inicio debe ser anterior a la de fin para $day.';
        }
      }
    }
    return null; // Si no hay errores, retorna null
  }

  // --- MÉTODO PARA MOSTRAR ERRORES EN UN SNACKBAR ---
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Theme.of(context).colorScheme.error,
    ));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final skills = context.read<RegisterProvider>().skills;
    if (_selectedSkills.isEmpty && skills.isNotEmpty) {
      setState(() {
        for (var skill in skills) {
          _selectedSkills[skill.id] = false;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final registerProvider = context.watch<RegisterProvider>();
    final skills = registerProvider.skills;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (registerProvider.status == RegisterStatus.success) {
        // Usamos context.go para limpiar la pila de navegación de registro
        context.go(AppRoutes.loginPath);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('¡Registro completado! Ya puedes iniciar sesión.'),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ));
      } else if (registerProvider.status == RegisterStatus.error) {
        _showErrorSnackBar(registerProvider.errorMessage ?? 'Ocurrió un error al registrar.');
      }
    });

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BackButtonCustom(),
              const SizedBox(height: 16),
              Text('Habilidades y Disponibilidad', style: textTheme.headlineMedium),
              const SizedBox(height: 24),
              Text('Habilidades', style: textTheme.titleLarge),
              const SizedBox(height: 4),
              Text('Indica las habilidades en las que te consideras bueno. (Al menos una)', style: textTheme.bodyMedium),
              const SizedBox(height: 16),
              ...skills.map((skill) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: CustomCheckbox(
                  label: skill.name,
                  value: _selectedSkills[skill.id] ?? false,
                  onChanged: (val) => setState(() => _selectedSkills[skill.id] = val!),
                ),
              )).toList(),
              const SizedBox(height: 32),
              Text('Disponibilidad', style: textTheme.titleLarge),
              const SizedBox(height: 4),
              Text('Selecciona los días y horas en los que puedes apoyar.', style: textTheme.bodyMedium),
              const SizedBox(height: 16),

              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _dayOrder.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final day = _dayOrder[index];
                  return AvailabilityDayCard(
                    dayName: day,
                    dayInitial: day.substring(0, 1),
                    isSelected: _daysSelected[day]!,
                    startTime: _startTimes[day],
                    endTime: _endTimes[day],
                    onDaySelected: (isSelected) {
                      setState(() => _daysSelected[day] = isSelected);
                    },
                    onStartTimeChanged: (time) {
                      setState(() => _startTimes[day] = time);
                    },
                    onEndTimeChanged: (time) {
                      setState(() => _endTimes[day] = time);
                    },
                  );
                },
              ),

              const SizedBox(height: 40),
              CustomButton(
                text: 'Finalizar Registro',
                onPressed: _handleFinalize,
                isLoading: registerProvider.status == RegisterStatus.loading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Extensión para capitalizar la primera letra del día para mensajes de error
extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}