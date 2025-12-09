import 'package:bienestar_integral_app/features/register_purchase/presentation/widgets/purchase_action_button.dart';
import 'package:bienestar_integral_app/features/register_purchase/presentation/widgets/purchase_form_field.dart';
import 'package:bienestar_integral_app/features/settings/presentation/widgets/home_app_bar.dart';
import 'package:flutter/material.dart';

class RegisterPurchaseScreen extends StatefulWidget {
  const RegisterPurchaseScreen({super.key});

  @override
  State<RegisterPurchaseScreen> createState() => _RegisterPurchaseScreenState();
}

class _RegisterPurchaseScreenState extends State<RegisterPurchaseScreen> {
  String? _selectedPurchaseType;
  final List<String> _purchaseTypes = ['Efectivo', 'Transferencia', 'Tarjeta'];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: const HomeAppBar(title: 'Registrar Compra', showBackButton: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Detalles de la Compra', style: textTheme.headlineMedium),
            const SizedBox(height: 32),

            // --- Formulario refactorizado con widgets ---
            PurchaseFormField(label: 'Fecha de compra', hint: 'mm/dd/yyyy', readOnly: true, onTap: () {}),
            const PurchaseFormField(label: 'Proveedor', hint: 'Ej. Chedraui'),
            PurchaseFormField(
              label: 'Tipo de compra',
              hint: 'Selecciona un método',
              fieldType: FieldType.dropdown,
              dropdownItems: _purchaseTypes,
              dropdownValue: _selectedPurchaseType,
              onDropdownChanged: (newValue) => setState(() => _selectedPurchaseType = newValue),
            ),
            const PurchaseFormField(label: 'Número de factura / ticket', hint: 'Ej. 293'),
            const PurchaseFormField(label: 'Total de compra', hint: '\$0.00', keyboardType: TextInputType.number),
            PurchaseFormField(label: 'Adjuntar ticket (OCR)', hint: 'Choose file', readOnly: true, onTap: () {}),

            const SizedBox(height: 32),
            _buildProductsSection(textTheme),
            const SizedBox(height: 32),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildProductsSection(TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Productos Comprados', style: textTheme.titleLarge),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Producto', style: textTheme.titleSmall),
              Text('Cantidad', style: textTheme.titleSmall),
              Text('Precio', style: textTheme.titleSmall),
              Text('Subtotal', style: textTheme.titleSmall),
            ],
          ),
        ),
        // Aquí iría la lista de productos agregados.
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        PurchaseActionButton(label: 'Agregar Producto', onPressed: () {}, isPrimary: false),
        const SizedBox(width: 12),
        PurchaseActionButton(label: 'Guardar Compra', onPressed: () {}),
      ],
    );
  }
}