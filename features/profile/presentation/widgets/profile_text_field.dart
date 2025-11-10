import 'package:flutter/material.dart';

class ProfileTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hintText;
  final bool isRequired;
  final IconData icon;

  // --- CAMBIO 1: Se añade la propiedad `keyboardType` ---
  final TextInputType? keyboardType;

  const ProfileTextField({
    super.key,
    required this.label,
    required this.controller,
    required this.hintText,
    this.isRequired = true,
    this.icon = Icons.person,
    // --- CAMBIO 2: Se añade el parámetro al constructor ---
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.titleSmall?.copyWith(
            color: colors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          // --- CAMBIO 3: Se pasa el parámetro al TextFormField interno ---
          keyboardType: keyboardType,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: colors.primary),
            hintText: hintText,
            hintStyle: theme.textTheme.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
          ),
          validator: isRequired
              ? (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor completa este campo';
            }
            return null;
          }
              : null,
        ),
      ],
    );
  }
}