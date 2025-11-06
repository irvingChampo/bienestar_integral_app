import 'package:bienestar_integral_app/core/application/app_state.dart';
import 'package:bienestar_integral_app/features/profile/presentation/widgets/confirmation_dialog.dart';
import 'package:bienestar_integral_app/features/settings/presentation/widgets/home_app_bar.dart';
import 'package:bienestar_integral_app/features/settings/presentation/widgets/settings_option_card.dart';
import 'package:bienestar_integral_app/features/settings/presentation/widgets/settings_section_header.dart';
import 'package:bienestar_integral_app/features/settings/presentation/widgets/settings_switch_card.dart';
import 'package:bienestar_integral_app/features/settings/presentation/widgets/theme_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _emailNotifications = true;

  void _handleDeleteAccount() {
    showDialog(
      context: context,
      builder: (_) => ConfirmationDialog(
        title: 'Eliminar cuenta',
        message: '¿Estás seguro? Esta acción no se puede deshacer.',
        confirmText: 'Eliminar',
        onConfirm: () {
          // Llama a logout del appState para redirigir al login
          context.read<AppState>().logout();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppBar(title: 'Configuración', showBackButton: true),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SettingsSectionHeader(title: 'Apariencia'),
          SettingsOptionCard(
            icon: Icons.palette,
            title: 'Tema',
            subtitle: 'Sistema',
            onTap: () => showDialog(context: context, builder: (_) => const ThemeDialog()),
          ),
          const SettingsSectionHeader(title: 'Notificaciones'),
          SettingsSwitchCard(
            icon: Icons.notifications,
            title: 'Notificaciones push',
            value: _notificationsEnabled,
            onChanged: (value) => setState(() => _notificationsEnabled = value),
          ),
          const SizedBox(height: 12),
          SettingsSwitchCard(
            icon: Icons.email,
            title: 'Notificaciones por correo',
            value: _emailNotifications,
            onChanged: (value) => setState(() => _emailNotifications = value),
          ),
          const SettingsSectionHeader(title: 'Información'),
          SettingsOptionCard(icon: Icons.privacy_tip, title: 'Política de privacidad', onTap: () {}),
          const SizedBox(height: 12),
          SettingsOptionCard(icon: Icons.description, title: 'Términos y condiciones', onTap: () {}),
          const SizedBox(height: 12),
          SettingsOptionCard(icon: Icons.info, title: 'Acerca de', subtitle: 'Versión 1.0.0', onTap: () {}),
          const SettingsSectionHeader(title: 'Cuenta'),
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