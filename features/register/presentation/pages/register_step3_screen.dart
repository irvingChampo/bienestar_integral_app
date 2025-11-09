import 'package:bienestar_integral_app/core/router/routes.dart';
import 'package:bienestar_integral_app/features/auth/presentation/widgets/custom_button.dart';
import 'package:bienestar_integral_app/features/register/domain/entities/skill.dart';
import 'package:bienestar_integral_app/features/register/presentation/providers/register_provider.dart';
import 'package:bienestar_integral_app/features/register/presentation/widgets/back_button_custom.dart';
import 'package:bienestar_integral_app/features/register/presentation/widgets/custom_checkbox.dart';
import 'package:bienestar_integral_app/features/register/presentation/widgets/day_selector.dart';
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
  final Map<String, bool> _availability = {
    'D': false, 'L': false, 'M': false, 'X': false, 'J': false, 'V': false, 'S': false,
  };

  void _handleFinalize() {
    final selectedSkillIds = _selectedSkills.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();

    if (selectedSkillIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Debes seleccionar al menos una habilidad'),
        backgroundColor: Theme.of(context).colorScheme.error,
      ));
      return;
    }

    final registerProvider = context.read<RegisterProvider>();
    registerProvider.saveStep3Data({
      'skillIds': selectedSkillIds,
      'availability': _availability,
    });

    registerProvider.submitRegistration();
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

    // Listener para manejar el resultado del registro
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (registerProvider.status == RegisterStatus.success) {
        context.go(AppRoutes.loginPath);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('¡Registro completado! Ya puedes iniciar sesión.'),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ));
      } else if (registerProvider.status == RegisterStatus.error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(registerProvider.errorMessage ?? 'Error desconocido'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ));
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
              DaySelector(
                selectedDays: _availability,
                onDayToggle: (day) => setState(() => _availability[day] = !_availability[day]!),
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