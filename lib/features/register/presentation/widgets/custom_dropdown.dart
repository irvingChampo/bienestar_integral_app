// features/register/presentation/widgets/custom_dropdown.dart (ACTUALIZADO)

import 'package:flutter/material.dart';

class CustomDropdown<T> extends StatelessWidget {
  final String label;
  final String hint;
  final IconData icon;
  final T? value;
  final List<T> items;
  final Function(T?) onChanged;
  final String? Function(T?)? validator;
  final Widget Function(T) itemBuilder;
  // --- CAMBIO: Añadimos la propiedad autovalidateMode ---
  final AutovalidateMode? autovalidateMode;

  const CustomDropdown({
    super.key,
    required this.label,
    required this.hint,
    required this.icon,
    required this.items,
    required this.onChanged,
    required this.itemBuilder,
    this.value,
    this.validator,
    this.autovalidateMode, // Se añade al constructor
  });

  @override
  Widget build(BuildContext context) {
    // ... (build method content remains the same until DropdownButtonFormField)
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ... (Text widget for label)
        const SizedBox(height: 8),
        DropdownButtonFormField<T>(
          value: value,
          hint: Text(hint, style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
          items: items.map((T item) {
            return DropdownMenuItem<T>(
              value: item,
              child: itemBuilder(item),
            );
          }).toList(),
          onChanged: onChanged,
          validator: validator,
          // --- CAMBIO: Se aplica el autovalidateMode al Dropdown ---
          autovalidateMode: autovalidateMode,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, size: 20),
          ),
        ),
      ],
    );
  }
}