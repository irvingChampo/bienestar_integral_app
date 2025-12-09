import 'package:bienestar_integral_app/features/payments/presentation/providers/payment_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class DonationDialog extends StatefulWidget {
  final int kitchenId;

  const DonationDialog({super.key, required this.kitchenId});

  @override
  State<DonationDialog> createState() => _DonationDialogState();
}

class _DonationDialogState extends State<DonationDialog> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _handleDonate() async {
    // 1. Validar formulario
    if (!(_formKey.currentState?.validate() ?? false)) return;

    // 2. Obtener valores
    final amount = double.tryParse(_amountController.text) ?? 0.0;
    final description = _descriptionController.text.trim();

    // 3. Llamar al provider
    // Usamos read porque es una acción única, no escuchamos cambios aquí
    final paymentProvider = context.read<PaymentProvider>();

    // Guardamos referencias para usar después del await
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final theme = Theme.of(context);

    // Ejecutar donación
    final success = await paymentProvider.makeDonation(
      kitchenId: widget.kitchenId,
      amount: amount,
      description: description.isNotEmpty ? description : null,
    );

    if (!mounted) return;

    if (success) {
      navigator.pop(); // Cerrar el diálogo

      // Mostrar feedback discreto
      messenger.showSnackBar(
        SnackBar(
          content: const Text('Redirigiendo a la pasarela de pago...'),
          backgroundColor: theme.colorScheme.primary,
          duration: const Duration(seconds: 4),
        ),
      );
    } else {
      // Mostrar error si falló
      messenger.showSnackBar(
        SnackBar(
          content: Text(paymentProvider.errorMessage ?? 'Error al procesar donación'),
          backgroundColor: theme.colorScheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Usamos watch para reconstruir el widget si cambia isLoading
    final provider = context.watch<PaymentProvider>();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Título ---
              Text(
                'Realizar Donación',
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Tu aporte ayuda a mantener esta cocina comunitaria.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),

              // --- Campo de Monto ---
              Text(
                'Monto a donar (MXN)',
                style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                // Permite solo números y hasta 2 decimales
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                style: theme.textTheme.bodyLarge,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.attach_money, color: theme.colorScheme.primary),
                  hintText: '0.00',
                  filled: true,
                  fillColor: theme.colorScheme.surfaceVariant.withOpacity(0.3),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingresa un monto';
                  }
                  final number = double.tryParse(value);
                  if (number == null || number <= 0) {
                    return 'El monto debe ser mayor a 0';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // --- Campo de Descripción (Opcional) ---
              Text(
                'Mensaje (Opcional)',
                style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descriptionController,
                maxLines: 2,
                style: theme.textTheme.bodyLarge,
                decoration: InputDecoration(
                  hintText: '¡Gracias por su labor!',
                  prefixIcon: Icon(Icons.comment_outlined, color: theme.colorScheme.primary),
                  filled: true,
                  fillColor: theme.colorScheme.surfaceVariant.withOpacity(0.3),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // --- Botones de Acción ---
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: provider.isLoading ? null : () => Navigator.pop(context),
                    child: const Text('Cancelar'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: provider.isLoading ? null : _handleDonate,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: provider.isLoading
                        ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: theme.colorScheme.onPrimary,
                      ),
                    )
                        : const Text('Donar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}