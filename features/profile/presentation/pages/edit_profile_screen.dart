import 'package:bienestar_integral_app/features/events/presentation/widgets/success_dialog.dart';
import 'package:bienestar_integral_app/features/profile/presentation/widgets/confirmation_dialog.dart';
import 'package:bienestar_integral_app/features/profile/presentation/widgets/edit_profile_header.dart';
import 'package:bienestar_integral_app/features/profile/presentation/widgets/profile_text_field.dart';
import 'package:bienestar_integral_app/features/profile/presentation/widgets/skill_checkbox_item.dart';
import 'package:bienestar_integral_app/features/settings/presentation/widgets/home_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _firstLastNameController = TextEditingController();
  final _secondLastNameController = TextEditingController();

  final Map<String, bool> _skills = {
    'Cocinero': false, 'Mesero': false, 'Personal de limpieza': false,
    'Coordinador de eventos': false, 'Ayudante de cocina': false,
    'Personal de apoyo (Multi-habilidades)': false,
  };

  @override
  void initState() {
    super.initState();
    // Simula la carga de datos del usuario
    _nameController.text = 'Juan';
    _firstLastNameController.text = 'Pérez';
    _secondLastNameController.text = 'García';
    _skills['Cocinero'] = true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _firstLastNameController.dispose();
    _secondLastNameController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (_formKey.currentState?.validate() ?? false) {
      showDialog(
        context: context,
        builder: (_) => ConfirmationDialog(
          title: 'Guardar cambios',
          message: '¿Deseas guardar los cambios realizados?',
          onConfirm: () {
            showDialog(
              context: context,
              builder: (_) => SuccessDialog(
                message: '¡Perfil actualizado exitosamente!',
                onClose: () => context.pop(), // Vuelve a la pantalla anterior
              ),
            );
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const HomeAppBar(title: 'Editar Perfil', showBackButton: true),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    EditProfileHeader(onCameraPressed: () {}),
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ProfileTextField(
                            label: 'Nombres', controller: _nameController,
                            hintText: 'Ingresa tus nombres', icon: Icons.person,
                          ),
                          const SizedBox(height: 16),
                          ProfileTextField(
                            label: 'Primer apellido', controller: _firstLastNameController,
                            hintText: 'Ingresa tu primer apellido', icon: Icons.person_outline,
                          ),
                          const SizedBox(height: 16),
                          ProfileTextField(
                            label: 'Segundo apellido', controller: _secondLastNameController,
                            hintText: 'Ingresa tu segundo apellido', icon: Icons.person_outline, isRequired: false,
                          ),
                          const SizedBox(height: 32),
                          Text('Habilidades', style: theme.textTheme.titleLarge),
                          const SizedBox(height: 16),
                          ..._skills.keys.map((skill) {
                            return SkillCheckboxItem(
                              title: skill,
                              value: _skills[skill]!,
                              onChanged: (bool? value) => setState(() => _skills[skill] = value ?? false),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Barra de acciones inferior
            _buildBottomActionBar(context),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomActionBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => context.pop(),
              child: const Text('Cancelar'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: _handleSave,
              child: const Text('Guardar'),
            ),
          ),
        ],
      ),
    );
  }
}