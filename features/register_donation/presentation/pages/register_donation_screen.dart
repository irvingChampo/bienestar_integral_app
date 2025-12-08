import 'package:bienestar_integral_app/features/auth/presentation/widgets/custom_button.dart';
import 'package:bienestar_integral_app/features/settings/presentation/widgets/home_app_bar.dart';
import 'package:bienestar_integral_app/shared/widgets/admin_text_field.dart';
import 'package:flutter/material.dart';

class RegisterDonationScreen extends StatefulWidget {
  const RegisterDonationScreen({super.key});

  @override
  State<RegisterDonationScreen> createState() => _RegisterDonationScreenState();
}

class _RegisterDonationScreenState extends State<RegisterDonationScreen> {
  String? _selectedDonationType;
  final List<String> _donationTypes = ['Monetaria', 'En Especie (Productos)'];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: const HomeAppBar(title: 'Registrar Donación', showBackButton: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Detalles de la Donación', style: textTheme.headlineMedium),
            const SizedBox(height: 32),
            const AdminTextField(label: 'Nombre del Donante'),
            const SizedBox(height: 20),
            _buildDropdown(textTheme),
            const SizedBox(height: 24),
            _buildDonatedProductsSection(textTheme),
            const SizedBox(height: 32),
            CustomButton(onPressed: () {}, text: 'Guardar Donación'),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tipo de Donación',
          style: textTheme.titleSmall?.copyWith(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w600,
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedDonationType,
          hint: const Text('Selecciona el tipo'),
          items: _donationTypes.map((String value) {
            return DropdownMenuItem<String>(value: value, child: Text(value));
          }).toList(),
          onChanged: (newValue) => setState(() => _selectedDonationType = newValue),
          decoration: const InputDecoration(),
        ),
      ],
    );
  }

  Widget _buildDonatedProductsSection(TextTheme textTheme) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Theme.of(context).colorScheme.outline.withOpacity(0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Productos Donados', style: textTheme.titleLarge),
            const SizedBox(height: 20),
            const Row(
              children: [
                Expanded(flex: 3, child: AdminTextField(label: 'Producto')),
                SizedBox(width: 12),
                Expanded(flex: 2, child: AdminTextField(label: 'Cantidad')),
              ],
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add),
                label: const Text('Agregar Producto'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}