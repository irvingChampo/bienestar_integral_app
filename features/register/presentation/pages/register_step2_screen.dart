import 'package:bienestar_integral_app/core/router/routes.dart';
import 'package:bienestar_integral_app/features/auth/presentation/widgets/custom_button.dart';
import 'package:bienestar_integral_app/features/auth/presentation/widgets/logo_avatar.dart';
import 'package:bienestar_integral_app/features/register/presentation/widgets/back_button_custom.dart';
import 'package:bienestar_integral_app/features/register/presentation/widgets/verification_field.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RegisterStep2Screen extends StatefulWidget {
  const RegisterStep2Screen({super.key});

  @override
  State<RegisterStep2Screen> createState() => _RegisterStep2ScreenState();
}

class _RegisterStep2ScreenState extends State<RegisterStep2Screen> {
  bool _emailVerified = false;
  bool _phoneVerified = false;

  void _handleContinue() {
    if (!_emailVerified || !_phoneVerified) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Debes verificar tu correo y teléfono'),
          // CAMBIO: Se usa el color de error del tema.
          backgroundColor: Theme.of(context).colorScheme.error, // ANTES: Colors.red
        ),
      );
      return;
    }
    context.push(AppRoutes.registerStep3Path);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BackButtonCustom(),
              const SizedBox(height: 16),
              Text('Completar perfil', style: textTheme.headlineMedium),
              const SizedBox(height: 4),
              Text('Ayúdanos a completar tu perfil', style: textTheme.bodyMedium),
              const SizedBox(height: 32),
              Center(
                child: Stack(
                  children: [
                    const LogoAvatar(size: 120),
                    Positioned(
                      bottom: 0, right: 0,
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                          width: 36, height: 36,
                          decoration: BoxDecoration(
                            color: colors.primary,
                            shape: BoxShape.circle,
                            // CAMBIO: Se usa el color `surface` para el borde, que se adapta al tema.
                            border: Border.all(color: colors.surface, width: 2), // ANTES: Colors.white
                          ),
                          // CAMBIO: Se usa el color `onPrimary` para el icono.
                          child: Icon(Icons.camera_alt, color: colors.onPrimary, size: 18), // ANTES: Colors.white
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              VerificationField(
                label: 'Correo electrónico', hint: 'irvingchampo@gmail.com', icon: Icons.email_outlined,
                onVerify: () => setState(() => _emailVerified = true),
                isVerified: _emailVerified,
              ),
              const SizedBox(height: 24),
              VerificationField(
                label: 'N. Telefono', hint: '9612743191', icon: Icons.phone_outlined,
                onVerify: () => setState(() => _phoneVerified = true),
                isVerified: _phoneVerified,
              ),
              const SizedBox(height: 40),
              CustomButton(text: 'Continuar', onPressed: _handleContinue),
            ],
          ),
        ),
      ),
    );
  }
}