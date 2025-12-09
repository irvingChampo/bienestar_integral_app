import 'package:bienestar_integral_app/core/router/routes.dart';
import 'package:bienestar_integral_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:bienestar_integral_app/features/auth/presentation/widgets/custom_button.dart';
import 'package:bienestar_integral_app/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:bienestar_integral_app/features/auth/presentation/widgets/forgot_password_link.dart';
import 'package:bienestar_integral_app/features/auth/presentation/widgets/login_header.dart';
import 'package:bienestar_integral_app/features/auth/presentation/widgets/logo_avatar.dart';
import 'package:bienestar_integral_app/features/auth/presentation/widgets/register_link.dart';
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

  // --- NUEVA FUNCIÓN PARA MANEJAR EL LOGIN CON GOOGLE ---
  void _handleGoogleLogin() async {
    final authProvider = context.read<AuthProvider>();

    // Iniciamos el proceso y esperamos a ver si nos devuelve datos de pre-llenado
    final prefillData = await authProvider.signInWithGoogle();

    if (!mounted) return;

    // Si prefillData NO es nulo, significa que es un usuario nuevo
    if (prefillData != null) {
      // Redirigimos al registro pasando los datos (email, nombre, foto)
      context.push(
        AppRoutes.registerStep1Path,
        extra: prefillData,
      );
    }
    // Si prefillData ES nulo, el AuthProvider ya manejó el login exitoso o el error.
  }

  @override
  Widget build(BuildContext context) {
    // Usamos watch para escuchar cambios de estado (loading, errores)
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
                  validator: AppValidators.emailValidator,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: _passwordController,
                  label: 'Contraseña',
                  icon: Icons.lock_outline,
                  isPassword: true,
                  validator: AppValidators.passwordValidator,
                ),
                const SizedBox(height: 12),
                ForgotPasswordLink(onTap: () {}),
                const SizedBox(height: 24),

                // Botón de Login Normal
                CustomButton(
                  text: 'Iniciar Sesión',
                  onPressed: _handleLogin,
                  isLoading: authProvider.isLoading,
                ),

                const SizedBox(height: 16),

                // Mensaje de Error (si existe)
                if (authProvider.errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      authProvider.errorMessage!,
                      style: TextStyle(color: colors.error),
                      textAlign: TextAlign.center,
                    ),
                  ),

                // --- BOTÓN DE GOOGLE ---
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: authProvider.isLoading ? null : _handleGoogleLogin,
                    icon: Image.network(
                      'https://upload.wikimedia.org/wikipedia/commons/c/c1/Google_%22G%22_logo.svg',
                      height: 24,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const SizedBox(width: 24, height: 24);
                      },
                      errorBuilder: (context, error, stackTrace) =>
                          Icon(Icons.login, color: colors.primary),
                    ),
                    label: const Text('Continuar con Google'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: BorderSide(color: colors.outline.withOpacity(0.5)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                // -----------------------

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