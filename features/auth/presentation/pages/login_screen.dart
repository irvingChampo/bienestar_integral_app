// features/auth/presentation/pages/login_screen.dart (ACTUALIZADO)

import 'package:bienestar_integral_app/core/router/routes.dart';
import 'package:bienestar_integral_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:bienestar_integral_app/features/auth/presentation/widgets/custom_button.dart';
import 'package:bienestar_integral_app/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:bienestar_integral_app/features/auth/presentation/widgets/forgot_password_link.dart';
import 'package:bienestar_integral_app/features/auth/presentation/widgets/login_header.dart';
import 'package:bienestar_integral_app/features/auth/presentation/widgets/logo_avatar.dart';
import 'package:bienestar_integral_app/features/auth/presentation/widgets/register_link.dart';
// --- CAMBIO: Importamos los nuevos validadores ---
import 'package:bienestar_integral_app/shared/validators/validators.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    FocusManager.instance.primaryFocus?.unfocus();

    if (_formKey.currentState?.validate() ?? false) {
      final authProvider = context.read<AuthProvider>();
      authProvider.login(
        _emailController.text,
        _passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 40),
                const LoginHeader(
                  title: 'Bienvenido',
                  subtitle: 'Inicia sesión para continuar',
                ),
                const SizedBox(height: 40),
                const LogoAvatar(size: 120),
                const SizedBox(height: 40),
                CustomTextField(
                  controller: _emailController,
                  label: 'Correo electrónico',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  // --- CAMBIO: Se utiliza el nuevo validador de email ---
                  validator: AppValidators.emailValidator,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: _passwordController,
                  label: 'Contraseña',
                  icon: Icons.lock_outline,
                  isPassword: true,
                  // --- CAMBIO: Se utiliza el nuevo validador de contraseña ---
                  validator: AppValidators.passwordValidator,
                ),
                const SizedBox(height: 12),
                ForgotPasswordLink(onTap: () {}),
                const SizedBox(height: 24),
                CustomButton(
                  text: 'Iniciar Sesión',
                  onPressed: _handleLogin,
                  isLoading: authProvider.isLoading,
                ),

                const SizedBox(height: 16),
                if (authProvider.errorMessage != null)
                  Text(
                    authProvider.errorMessage!,
                    style: TextStyle(color: colors.error),
                    textAlign: TextAlign.center,
                  ),

                const SizedBox(height: 24),
                RegisterLink(onTap: () => context.push(AppRoutes.registerStep1Path)),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}