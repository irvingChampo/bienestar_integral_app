import 'package:bienestar_integral_app/features/auth/presentation/widgets/custom_button.dart';
import 'package:bienestar_integral_app/features/events/presentation/widgets/success_dialog.dart';
import 'package:bienestar_integral_app/features/profile/presentation/widgets/confirmation_dialog.dart';
import 'package:bienestar_integral_app/features/settings/presentation/widgets/home_app_bar.dart';
import 'package:bienestar_integral_app/shared/widgets/admin_text_field.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _productNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _quantityController = TextEditingController();
  final _dateController = TextEditingController();
  DateTime? _selectedDate;

  @override
  void dispose() {
    _productNameController.dispose();
    _descriptionController.dispose();
    _quantityController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(), // No se pueden ingresar productos a futuro
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
      });
    }
  }

  void _handleAddProduct() {
    if (_formKey.currentState?.validate() ?? false) {
      showDialog(
        context: context,
        builder: (_) => ConfirmationDialog(
          title: '¿Agregar producto?',
          message: '¿Estás seguro de que deseas agregar este producto al inventario?',
          onConfirm: () {
            // Lógica para guardar el producto iría aquí

            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => SuccessDialog(
                message: '¡Producto agregado exitosamente!',
                onClose: () {
                  context.pop(); // Vuelve a la pantalla de admin home
                },
              ),
            );
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: const HomeAppBar(title: 'Añadir Producto', showBackButton: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Registrar Nuevo Producto', style: textTheme.headlineMedium),
              const SizedBox(height: 32),

              AdminTextField(
                label: 'Nombre del producto',
                controller: _productNameController,
                validator: (v) => v == null || v.isEmpty ? 'Ingresa el nombre del producto' : null,
              ),
              const SizedBox(height: 20),

              AdminTextField(
                label: 'Descripción',
                controller: _descriptionController,
                maxLines: 3,
                validator: (v) => v == null || v.isEmpty ? 'Ingresa una descripción' : null,
              ),
              const SizedBox(height: 20),

              AdminTextField(
                label: 'Cantidad disponible',
                controller: _quantityController,
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Ingresa la cantidad';
                  if (int.tryParse(v) == null || int.parse(v) <= 0) {
                    return 'Ingresa un número válido y mayor a cero';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              AdminTextField(
                label: 'Fecha de ingreso',
                controller: _dateController,
                hint: 'dd/mm/yyyy',
                readOnly: true,
                onTap: _selectDate,
                validator: (v) => v == null || v.isEmpty ? 'Selecciona una fecha' : null,
              ),
              const SizedBox(height: 32),

              CustomButton(
                text: 'Agregar Producto',
                onPressed: _handleAddProduct,
              ),
            ],
          ),
        ),
      ),
    );
  }
}