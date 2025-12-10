import 'package:bienestar_integral_app/features/admin_home/presentation/providers/admin_home_provider.dart';
import 'package:bienestar_integral_app/features/auth/presentation/widgets/custom_button.dart';
import 'package:bienestar_integral_app/features/events/presentation/widgets/success_dialog.dart';
import 'package:bienestar_integral_app/features/inventory/domain/entities/category.dart';
import 'package:bienestar_integral_app/features/inventory/domain/entities/unit.dart';
import 'package:bienestar_integral_app/features/inventory/presentation/providers/inventory_provider.dart';
import 'package:bienestar_integral_app/features/settings/presentation/widgets/home_app_bar.dart';
import 'package:bienestar_integral_app/shared/widgets/admin_text_field.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _productNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _shelfLifeController = TextEditingController();

  int? _selectedCategoryId;
  String? _selectedUnitKey;
  bool _isPerishable = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Cargar categorías y UNIDADES al iniciar la pantalla
      final provider = context.read<InventoryProvider>();
      provider.loadCategories();
      provider.loadUnits();
    });
  }

  @override
  void dispose() {
    _productNameController.dispose();
    _descriptionController.dispose();
    _shelfLifeController.dispose();
    super.dispose();
  }

  void _showAddCategoryDialog() {
    final nameCtrl = TextEditingController();
    final descCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Nueva Categoría'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Nombre')),
            const SizedBox(height: 12),
            TextField(controller: descCtrl, decoration: const InputDecoration(labelText: 'Descripción')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () async {
              if (nameCtrl.text.isNotEmpty && descCtrl.text.isNotEmpty) {
                final success = await context.read<InventoryProvider>().createNewCategory(
                  nameCtrl.text.trim(),
                  descCtrl.text.trim(),
                );
                if (success && mounted) {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Categoría creada exitosamente')),
                  );
                }
              }
            },
            child: const Text('Crear'),
          )
        ],
      ),
    );
  }

  void _handleAddProduct() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedCategoryId == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Selecciona una categoría')));
        return;
      }
      if (_selectedUnitKey == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Selecciona una unidad de medida')));
        return;
      }

      final inventoryProvider = context.read<InventoryProvider>();
      final adminHomeProvider = context.read<AdminHomeProvider>();
      final kitchenId = adminHomeProvider.kitchen?.id;

      if (kitchenId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error: No se encontró la cocina del administrador.')),
        );
        return;
      }

      int? shelfLife;
      if (_isPerishable) {
        shelfLife = int.tryParse(_shelfLifeController.text);
        if (shelfLife == null || shelfLife <= 0) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ingresa días válidos para producto perecedero')));
          return;
        }
      } else {
        shelfLife = null;
      }

      final success = await inventoryProvider.registerProduct(
        kitchenId: kitchenId,
        name: _productNameController.text.trim(),
        description: _descriptionController.text.trim(),
        categoryId: _selectedCategoryId!,
        unit: _selectedUnitKey!,
        perishable: _isPerishable,
        shelfLifeDays: shelfLife,
      );

      if (mounted) {
        if (success) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => SuccessDialog(
              message: '¡Producto agregado exitosamente!',
              onClose: () {
                context.pop();
                context.pop();
              },
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(inventoryProvider.errorMessage ?? 'Error al agregar'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final provider = context.watch<InventoryProvider>();
    final categories = provider.categories;
    final units = provider.units;

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
                validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
              ),
              const SizedBox(height: 16),

              AdminTextField(
                label: 'Descripción',
                controller: _descriptionController,
                hint: 'Breve descripción del producto...',
                maxLines: 2,
                validator: (v) => null,
              ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Categoría', style: textTheme.titleSmall),
                  IconButton(
                    icon: const Icon(Icons.add_circle, color: Colors.blue),
                    onPressed: _showAddCategoryDialog,
                    tooltip: 'Crear nueva categoría',
                  ),
                ],
              ),
              DropdownButtonFormField<int>(
                value: _selectedCategoryId,
                hint: const Text('Seleccionar...'),
                items: categories.map((Category cat) {
                  return DropdownMenuItem<int>(
                    value: cat.id,
                    child: Text(cat.name),
                  );
                }).toList(),
                onChanged: (v) => setState(() => _selectedCategoryId = v),
                decoration: const InputDecoration(),
                validator: (v) => v == null ? 'Requerido' : null,
              ),
              const SizedBox(height: 20),

              Text('Unidad de medida', style: textTheme.titleSmall),
              const SizedBox(height: 8),

              // --- DROPDOWN MEJORADO PARA UNIDADES ---
              DropdownButtonFormField<String>(
                value: _selectedUnitKey,
                // Si la lista está vacía, mostramos texto de carga
                hint: Text(
                  units.isEmpty ? 'Cargando unidades...' : 'Seleccionar...',
                  style: TextStyle(color: units.isEmpty ? Colors.grey : null),
                ),
                // Deshabilitado si no hay datos
                onChanged: units.isEmpty ? null : (v) => setState(() => _selectedUnitKey = v),

                items: units.map((Unit u) {
                  return DropdownMenuItem<String>(
                    value: u.key, // Enviar clave al back
                    child: Text('${u.label} (${u.key})'), // Mostrar etiqueta bonita
                  );
                }).toList(),

                decoration: InputDecoration(
                  // Spinner pequeño a la derecha si está cargando
                  suffixIcon: units.isEmpty
                      ? const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: SizedBox(width: 10, height: 10, child: CircularProgressIndicator(strokeWidth: 2)),
                  )
                      : null,
                ),
                validator: (v) => v == null ? 'Requerido' : null,
              ),

              const SizedBox(height: 20),

              SwitchListTile(
                title: Text('¿Es perecedero?', style: textTheme.bodyLarge),
                value: _isPerishable,
                onChanged: (v) => setState(() => _isPerishable = v),
              ),

              if (_isPerishable) ...[
                const SizedBox(height: 16),
                AdminTextField(
                  label: 'Días de vida útil',
                  controller: _shelfLifeController,
                  keyboardType: TextInputType.number,
                  hint: 'Ej. 7',
                  validator: (v) => _isPerishable && (v == null || v.isEmpty) ? 'Requerido' : null,
                ),
              ],

              const SizedBox(height: 32),

              CustomButton(
                text: 'Agregar Producto',
                isLoading: provider.status == InventoryStatus.loading,
                onPressed: _handleAddProduct,
              ),
            ],
          ),
        ),
      ),
    );
  }
}