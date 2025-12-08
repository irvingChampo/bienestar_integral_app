import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:bienestar_integral_app/core/router/routes.dart';
import 'package:bienestar_integral_app/features/auth/presentation/widgets/custom_button.dart';
import 'package:bienestar_integral_app/features/kitchen_schedule/presentation/providers/kitchen_schedule_provider.dart';
import 'package:bienestar_integral_app/features/settings/presentation/widgets/home_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class KitchenScheduleScreen extends StatelessWidget {
  final int kitchenId;

  const KitchenScheduleScreen({super.key, required this.kitchenId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => KitchenScheduleProvider(),
      child: _KitchenScheduleBody(kitchenId: kitchenId),
    );
  }
}

class _KitchenScheduleBody extends StatelessWidget {
  final int kitchenId;
  const _KitchenScheduleBody({required this.kitchenId});

  Future<void> _pickTime(BuildContext context, bool isWeekend, bool isStart) async {
    final provider = context.read<KitchenScheduleProvider>();
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: 9, minute: 0),
    );
    if (picked != null) {
      provider.updateTime(isWeekend: isWeekend, isStart: isStart, time: picked);
    }
  }

  void _handleSave(BuildContext context) async {
    final provider = context.read<KitchenScheduleProvider>();
    final success = await provider.saveSchedules(kitchenId);

    if (success && context.mounted) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.bottomSlide,
        title: '¡Horarios Configurados!',
        desc: 'Tu cocina está lista para recibir voluntarios.',
        btnOkOnPress: () {
          // Redirigir al Admin Home y limpiar el stack para no volver aquí
          context.go(AppRoutes.adminHomePath);
        },
      ).show();
    } else if (provider.status == ScheduleStatus.error && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(provider.errorMessage ?? 'Error'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<KitchenScheduleProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      // showBackButton: false para obligar a configurar
      appBar: const HomeAppBar(title: 'Configuración Inicial', showBackButton: false),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bienvenido Administrador',
              style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Antes de comenzar, necesitamos configurar los horarios de atención de tu cocina.',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 32),

            _buildSectionHeader(theme, 'Lunes a Viernes'),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildTimeCard(context, 'Apertura', provider.weekStart, () => _pickTime(context, false, true)),
                const SizedBox(width: 16),
                _buildTimeCard(context, 'Cierre', provider.weekEnd, () => _pickTime(context, false, false)),
              ],
            ),

            const SizedBox(height: 32),

            _buildSectionHeader(theme, 'Fines de Semana'),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildTimeCard(context, 'Apertura', provider.weekendStart, () => _pickTime(context, true, true)),
                const SizedBox(width: 16),
                _buildTimeCard(context, 'Cierre', provider.weekendEnd, () => _pickTime(context, true, false)),
              ],
            ),

            const SizedBox(height: 48),

            CustomButton(
              text: 'Guardar y Continuar',
              isLoading: provider.status == ScheduleStatus.loading,
              onPressed: () => _handleSave(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(ThemeData theme, String title) {
    return Row(
      children: [
        Icon(Icons.access_time_filled, color: theme.colorScheme.primary),
        const SizedBox(width: 8),
        Text(title, style: theme.textTheme.titleLarge),
      ],
    );
  }

  Widget _buildTimeCard(BuildContext context, String label, TimeOfDay? time, VoidCallback onTap) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          decoration: BoxDecoration(
            color: colors.surface,
            border: Border.all(color: colors.outline.withOpacity(0.3)),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(color: colors.shadow.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))
            ],
          ),
          child: Column(
            children: [
              Text(label, style: theme.textTheme.labelMedium?.copyWith(color: colors.onSurfaceVariant)),
              const SizedBox(height: 8),
              Text(
                time != null ? time.format(context) : '--:--',
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: time != null ? colors.primary : colors.outline,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}