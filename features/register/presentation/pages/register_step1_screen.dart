import 'package:bienestar_integral_app/core/router/routes.dart';
import 'package:bienestar_integral_app/features/auth/presentation/widgets/custom_button.dart';
import 'package:bienestar_integral_app/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:bienestar_integral_app/features/register/presentation/widgets/back_button_custom.dart';
import 'package:bienestar_integral_app/features/register/presentation/widgets/custom_checkbox.dart';
import 'package:bienestar_integral_app/features/register/presentation/widgets/custom_dropdown.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RegisterStep1Screen extends StatefulWidget {
  const RegisterStep1Screen({super.key});

  @override
  State<RegisterStep1Screen> createState() => _RegisterStep1ScreenState();
}

class _RegisterStep1ScreenState extends State<RegisterStep1Screen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  String? _selectedEstado;
  bool _acceptTerms = false;
  final List<String> _estados = ['Chiapas', 'Ciudad de México', 'Jalisco'];

  void _handleContinue() {
    if (_formKey.currentState?.validate() ?? false) {
      if (!_acceptTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Debes aceptar los términos y condiciones'), backgroundColor: Colors.red),
        );
        return;
      }
      context.push(AppRoutes.registerStep2Path);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const BackButtonCustom(),
                const SizedBox(height: 16),
                Text('Crear Cuenta', style: textTheme.headlineMedium),
                const SizedBox(height: 4),
                Text('Regístrate para comenzar', style: textTheme.bodyMedium),
                const SizedBox(height: 32),
                const CustomTextField(label: 'Nombres', icon: Icons.person_outline),
                const SizedBox(height: 16),
                const CustomTextField(label: 'Primer apellido', icon: Icons.person_outline),
                const SizedBox(height: 16),
                const CustomTextField(label: 'Segundo apellido', icon: Icons.person_outline),
                const SizedBox(height: 16),
                CustomDropdown(
                  label: 'Estado', hint: 'Selecciona un estado', icon: Icons.location_on_outlined,
                  items: _estados, value: _selectedEstado,
                  onChanged: (value) => setState(() => _selectedEstado = value),
                  validator: (value) => value == null ? 'Selecciona un estado' : null,
                ),
                const SizedBox(height: 16),
                const CustomTextField(label: 'Municipio', icon: Icons.location_on_outlined),
                const SizedBox(height: 16),
                const CustomTextField(label: 'Correo electrónico', icon: Icons.email_outlined, keyboardType: TextInputType.emailAddress),
                const SizedBox(height: 16),
                CustomTextField(controller: _passwordController, label: 'Contraseña', icon: Icons.lock_outline, isPassword: true),
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'Confirmar contraseña', icon: Icons.lock_outline, isPassword: true,
                  validator: (v) => v != _passwordController.text ? 'Las contraseñas no coinciden' : null,
                ),
                const SizedBox(height: 20),
                CustomCheckbox(
                  label: 'Acepto los Términos y condiciones', value: _acceptTerms,
                  onChanged: (value) => setState(() => _acceptTerms = value ?? false),
                  isTerms: true,
                ),
                const SizedBox(height: 32),
                CustomButton(text: 'Registrarse', onPressed: _handleContinue),
                const SizedBox(height: 16),
                Center(
                  child: RichText(
                    text: TextSpan(
                      style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                      children: [
                        const TextSpan(text: '¿Ya tienes cuenta? '),
                        TextSpan(
                          text: 'Iniciar sesión',
                          style: TextStyle(fontWeight: FontWeight.bold, color: colorScheme.primary),
                          recognizer: TapGestureRecognizer()..onTap = () => context.pop(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}