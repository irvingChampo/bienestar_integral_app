import 'package:bienestar_integral_app/core/router/routes.dart';
import 'package:bienestar_integral_app/features/auth/presentation/widgets/custom_button.dart';
import 'package:bienestar_integral_app/features/register/presentation/widgets/back_button_custom.dart';
import 'package:bienestar_integral_app/features/register/presentation/widgets/custom_checkbox.dart';
import 'package:bienestar_integral_app/features/register/presentation/widgets/day_selector.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RegisterStep3Screen extends StatefulWidget {
  const RegisterStep3Screen({super.key});

  @override
  State<RegisterStep3Screen> createState() => _RegisterStep3ScreenState();
}

class _RegisterStep3ScreenState extends State<RegisterStep3Screen> {
  final Map<String, bool> _skills = {
    'Cocinero': false, 'Mesero': false, 'Personal de limpieza': false,
    'Coordinador de eventos': false, 'Ayudante de cocina': false,
    'Personal de apoyo (Multi-habilidades)': false,
  };

  final Map<String, bool> _availability = {
    'D': false, 'L': false, 'M': false, 'X': false, 'J': false, 'V': false, 'S': false,
  };

  void _handleContinue() {
    // Lógica de validación
    context.go(AppRoutes.loginPath); // Redirige al login después de registrar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: const Text('¡Registro completado exitosamente!'), backgroundColor: Theme.of(context).colorScheme.primary),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

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
              ..._skills.keys.map((skill) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: CustomCheckbox(
                  label: skill,
                  value: _skills[skill]!,
                  onChanged: (val) => setState(() => _skills[skill] = val!),
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
              CustomButton(text: 'Finalizar Registro', onPressed: _handleContinue),
            ],
          ),
        ),
      ),
    );
  }
}