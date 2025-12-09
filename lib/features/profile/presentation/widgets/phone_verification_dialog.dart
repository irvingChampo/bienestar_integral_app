import 'package:bienestar_integral_app/features/profile/presentation/providers/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class PhoneVerificationDialog extends StatefulWidget {
  const PhoneVerificationDialog({super.key});

  @override
  State<PhoneVerificationDialog> createState() => _PhoneVerificationDialogState();
}

class _PhoneVerificationDialogState extends State<PhoneVerificationDialog> {
  final _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _handleVerify() async {
    final code = _codeController.text.trim();
    if (code.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El código debe tener 6 dígitos')),
      );
      return;
    }

    // Llamamos al provider
    final profileProvider = context.read<ProfileProvider>();
    final success = await profileProvider.verifyPhoneCode(code);

    if (mounted) {
      if (success) {
        Navigator.pop(context); // Cerramos el diálogo si fue exitoso
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('¡Teléfono verificado correctamente!')),
        );
      } else {
        // Si hubo error, mostramos el mensaje del provider
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(profileProvider.errorMessage ?? 'Código inválido'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  void _handleResend() async {
    final profileProvider = context.read<ProfileProvider>();
    final success = await profileProvider.sendPhoneVerification();

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Código reenviado exitosamente.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(profileProvider.errorMessage ?? 'Error al reenviar'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Usamos watch para reaccionar a cambios de estado (como isLoading)
    final profileProvider = context.watch<ProfileProvider>();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Verificar teléfono',
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Ingresa el código de 6 dígitos que enviamos a tu número celular.',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),

            // Campo para el código
            TextField(
              controller: _codeController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              maxLength: 6,
              style: theme.textTheme.headlineSmall?.copyWith(letterSpacing: 4),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                hintText: '000000',
                counterText: '', // Oculta el contador de caracteres
                filled: true,
                fillColor: theme.colorScheme.surfaceVariant.withOpacity(0.3),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Botones de acción
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: profileProvider.isVerificationLoading ? null : () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: profileProvider.isVerificationLoading ? null : _handleVerify,
                  child: profileProvider.isVerificationLoading
                      ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: theme.colorScheme.onPrimary,
                    ),
                  )
                      : const Text('Verificar'),
                ),
              ],
            ),

            const SizedBox(height: 16),
            Center(
              child: TextButton(
                onPressed: profileProvider.isVerificationLoading ? null : _handleResend,
                child: Text(
                  '¿No recibiste el código? Reenviar',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.primary,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}