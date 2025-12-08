import 'package:bienestar_integral_app/core/router/routes.dart';
import 'package:bienestar_integral_app/features/auth/presentation/widgets/custom_button.dart';
import 'package:bienestar_integral_app/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:bienestar_integral_app/features/register/domain/entities/municipality.dart';
import 'package:bienestar_integral_app/features/register/domain/entities/state.dart'
as app;
import 'package:bienestar_integral_app/features/register/presentation/providers/register_provider.dart';
import 'package:bienestar_integral_app/features/register/presentation/widgets/back_button_custom.dart';
import 'package:bienestar_integral_app/features/register/presentation/widgets/custom_dropdown.dart';
import 'package:bienestar_integral_app/features/register/presentation/widgets/password_validation_widget.dart';
import 'package:bienestar_integral_app/features/register/presentation/widgets/privacy_notice_widget.dart';
import 'package:bienestar_integral_app/shared/validators/validators.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class RegisterStep1Screen extends StatefulWidget {
  const RegisterStep1Screen({super.key});

  @override
  State<RegisterStep1Screen> createState() => _RegisterStep1ScreenState();
}

class _RegisterStep1ScreenState extends State<RegisterStep1Screen> {
  final _formKey = GlobalKey<FormState>();
  final _namesCtrl = TextEditingController();
  final _firstLastNameCtrl = TextEditingController();
  final _secondLastNameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();

  late final PasswordValidationController _passwordValidationCtrl;

  app.State? _selectedState;
  Municipality? _selectedMunicipality;
  bool _acceptPrivacyNotice = false;

  @override
  void initState() {
    super.initState();
    _passwordValidationCtrl = PasswordValidationController();

    // --- LÓGICA AÑADIDA PARA CORREGIR EL ERROR ---
    // Reseteamos el provider al iniciar la pantalla.
    // Usamos addPostFrameCallback para evitar errores de construcción.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RegisterProvider>().resetForm();
    });
    // --------------------------------------------
  }

  @override
  void dispose() {
    _namesCtrl.dispose();
    _firstLastNameCtrl.dispose();
    _secondLastNameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    _passwordValidationCtrl.dispose();
    super.dispose();
  }

  void _handleContinue() {
    FocusManager.instance.primaryFocus?.unfocus();

    if (_formKey.currentState?.validate() ?? false) {
      if (!_acceptPrivacyNotice) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('Debes aceptar el Aviso de Privacidad para continuar'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ));
        return;
      }

      final registerProvider = context.read<RegisterProvider>();
      registerProvider.saveStep1Data({
        'names': _namesCtrl.text,
        'firstLastName': _firstLastNameCtrl.text,
        'secondLastName': _secondLastNameCtrl.text,
        'email': _emailCtrl.text,
        'phoneNumber': _phoneCtrl.text,
        'password': _passwordCtrl.text,
        'stateId': _selectedState!.id,
        'municipalityId': _selectedMunicipality!.id,
      });

      context.push(AppRoutes.registerStep3Path);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final registerProvider = context.watch<RegisterProvider>();

    if (registerProvider.status == RegisterStatus.loading &&
        registerProvider.states.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (registerProvider.status == RegisterStatus.error) {
      return Scaffold(
          body: Center(child: Text(registerProvider.errorMessage ?? 'Error')));
    }

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
                CustomTextField(
                  label: 'Nombres',
                  hintText: 'Ingresa tus nombres',
                  icon: Icons.person_outline,
                  controller: _namesCtrl,
                  validator: (value) =>
                      AppValidators.nameValidator(value, 'nombre'),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'Primer apellido',
                  hintText: 'Ingresa tu primer apellido',
                  icon: Icons.person_outline,
                  controller: _firstLastNameCtrl,
                  validator: (value) =>
                      AppValidators.nameValidator(value, 'primer apellido'),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'Segundo apellido (Opcional)',
                  hintText: 'Ingresa tu segundo apellido',
                  icon: Icons.person_outline,
                  controller: _secondLastNameCtrl,
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      return AppValidators.nameValidator(value, 'segundo apellido');
                    }
                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                const SizedBox(height: 16),
                CustomDropdown<app.State>(
                  label: 'Estado',
                  hint: 'Selecciona un estado',
                  icon: Icons.location_city_outlined,
                  value: _selectedState,
                  items: registerProvider.states,
                  onChanged: (value) {
                    setState(() {
                      _selectedState = value;
                      _selectedMunicipality = null;
                    });
                    if (value != null) {
                      context.read<RegisterProvider>().fetchMunicipalities(value.id);
                    }
                  },
                  itemBuilder: (state) => Text(state.name),
                  validator: (value) =>
                  value == null ? 'Selecciona un estado' : null,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                const SizedBox(height: 16),
                CustomDropdown<Municipality>(
                  label: 'Municipio',
                  hint: 'Selecciona un municipio',
                  icon: Icons.location_on_outlined,
                  value: _selectedMunicipality,
                  items: registerProvider.municipalities,
                  onChanged: (value) =>
                      setState(() => _selectedMunicipality = value),
                  itemBuilder: (municipality) => Text(municipality.name),
                  validator: (value) =>
                  value == null ? 'Selecciona un municipio' : null,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'Correo electrónico',
                  hintText: 'ejemplo@correo.com',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailCtrl,
                  validator: AppValidators.emailValidator,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'Teléfono',
                  hintText: 'Tu número de teléfono (10 dígitos)',
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  controller: _phoneCtrl,
                  validator: AppValidators.phoneValidator,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _passwordCtrl,
                  label: 'Contraseña',
                  hintText: 'Ingresa tu contraseña',
                  icon: Icons.lock_outline,
                  isPassword: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingresa tu contraseña.';
                    }
                    if (!_passwordValidationCtrl.isPasswordValid) {
                      return 'La contraseña no cumple los requisitos.';
                    }
                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                const SizedBox(height: 12),
                PasswordValidationWidget(
                  passwordController: _passwordCtrl,
                  validationController: _passwordValidationCtrl,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'Confirmar contraseña',
                  hintText: 'Confirma tu contraseña',
                  icon: Icons.lock_outline,
                  isPassword: true,
                  controller: _confirmPasswordCtrl,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, confirma tu contraseña.';
                    }
                    if (value != _passwordCtrl.text) {
                      return 'Las contraseñas no coinciden.';
                    }
                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                const SizedBox(height: 20),

                PrivacyNoticeWidget(
                  value: _acceptPrivacyNotice,
                  onChanged: (value) =>
                      setState(() => _acceptPrivacyNotice = value),
                ),

                const SizedBox(height: 32),
                CustomButton(text: 'Continuar', onPressed: _handleContinue),
                const SizedBox(height: 16),
                Center(
                  child: RichText(
                    text: TextSpan(
                      style: textTheme.bodyMedium
                          ?.copyWith(color: colorScheme.onSurfaceVariant),
                      children: [
                        const TextSpan(text: '¿Ya tienes cuenta? '),
                        TextSpan(
                          text: 'Iniciar sesión',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.primary),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => context.pop(),
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