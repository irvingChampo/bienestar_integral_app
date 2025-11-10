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
// --- CAMBIO: Se manejará la disponibilidad horaria ---
  final Map<String, TimeOfDay?> _startTimes = {};
  final Map<String, TimeOfDay?> _endTimes = {};
  final Map<String, bool> _daysSelected = {
    'Lunes': false, 'Martes': false, 'Miércoles': false, 'Jueves': false, 'Viernes': false, 'Sábado': false, 'Domingo': false
  };
  final List<String> _dayOrder = ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'];
  void _handleFinalize() {
    final selectedSkillIds = _selectedSkills.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();

    if (selectedSkillIds.isEmpty) {
      _showErrorSnackBar('Debes seleccionar al menos una habilidad');
      return;
    }

// Validar horarios
    for (var day in _dayOrder) {
      if (_daysSelected[day]!) {
        if (_startTimes[day] == null || _endTimes[day] == null) {
          _showErrorSnackBar('Debes seleccionar hora de inicio y fin para $day');
          return;
        }
      }
    }

    final registerProvider = context.read<RegisterProvider>();
    registerProvider.saveStep3Data({
      'skillIds': selectedSkillIds,
      'availability': _daysSelected,
      'startTimes': _startTimes,
      'endTimes': _endTimes,
    });

    registerProvider.submitRegistration();
  }
  void _showErrorSnackBar(String message) {
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
        context.go(AppRoutes.loginPath);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('¡Registro completado! Ya puedes iniciar sesión.'),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ));
      } else if (registerProvider.status == RegisterStatus.error) {
        _showErrorSnackBar(registerProvider.errorMessage ?? 'Error desconocido');
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
              Text('Indica las habilidades en las que te consideras bueno', style: textTheme.bodyMedium),
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
              const SizedBox(height: 16),

              // --- CAMBIO: Se reemplaza DaySelector por la nueva lista de widgets ---
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