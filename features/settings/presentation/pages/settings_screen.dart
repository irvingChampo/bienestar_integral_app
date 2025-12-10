import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:bienestar_integral_app/core/application/app_state.dart';
import 'package:bienestar_integral_app/core/application/theme_provider.dart';
import 'package:bienestar_integral_app/features/profile/presentation/providers/profile_provider.dart';
import 'package:bienestar_integral_app/features/settings/presentation/widgets/home_app_bar.dart';
import 'package:bienestar_integral_app/features/settings/presentation/widgets/info_contents.dart';
import 'package:bienestar_integral_app/features/settings/presentation/widgets/info_modal.dart';
import 'package:bienestar_integral_app/features/settings/presentation/widgets/settings_option_card.dart';
import 'package:bienestar_integral_app/features/settings/presentation/widgets/settings_section_header.dart';
import 'package:bienestar_integral_app/features/settings/presentation/widgets/theme_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  void _handleDeleteAccount() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.bottomSlide,
      title: 'Eliminar cuenta',
      desc: '¿Estás seguro? Esta acción eliminará permanentemente todos tus datos del servidor y no se puede deshacer.',
      btnCancelText: 'Cancelar',
      btnCancelOnPress: () {},
      btnOkText: 'Eliminar',
      btnOkColor: Colors.red,
      btnOkOnPress: () async {
        // Obtenemos los providers
        final profileProvider = context.read<ProfileProvider>();
        final appState = context.read<AppState>();

        // Llamada al backend para eliminar
        final success = await profileProvider.deleteUserAccount();

        if (!mounted) return;

        if (success) {
          // Si el servidor confirma el borrado, cerramos sesión localmente
          // Esto disparará la redirección automática al Login
          appState.logout();

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tu cuenta ha sido eliminada correctamente.')),
          );
        } else {
          // Si falla, mostramos el mensaje de error del backend
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(profileProvider.errorMessage ?? 'Error al eliminar cuenta'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      },
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return Scaffold(
      appBar: const HomeAppBar(title: 'Configuración', showBackButton: true),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SettingsSectionHeader(title: 'Apariencia'),
          SettingsOptionCard(
            icon: Icons.palette,
            title: 'Tema',
            subtitle: themeProvider.themeName,
            onTap: () => showDialog(context: context, builder: (_) => const ThemeDialog()),
          ),

          const SettingsSectionHeader(title: 'Información'),

          SettingsOptionCard(
            icon: Icons.privacy_tip,
            title: 'Política de privacidad',
            onTap: () => InfoModal.show(
              context,
              title: 'Política de Privacidad',
              content: InfoContents.privacyPolicy(context),
            ),
          ),
          const SizedBox(height: 12),

          SettingsOptionCard(
            icon: Icons.description,
            title: 'Términos y condiciones',
            onTap: () => InfoModal.show(
              context,
              title: 'Términos y Condiciones',
              content: InfoContents.termsAndConditions(context),
            ),
          ),
          const SizedBox(height: 12),

          SettingsOptionCard(
            icon: Icons.info,
            title: 'Acerca de',
            subtitle: 'Versión 1.0.0',
            onTap: () => InfoModal.show(
              context,
              title: 'Acerca de',
              content: InfoContents.aboutApp(context),
            ),
          ),

          const SettingsSectionHeader(title: 'Cuenta'),

          // Botón conectado
          SettingsOptionCard(
            icon: Icons.delete_forever,
            title: 'Eliminar cuenta',
            onTap: _handleDeleteAccount,
          ),
        ],
      ),
    );
  }
}