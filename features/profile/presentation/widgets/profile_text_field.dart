import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProfileTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final AutovalidateMode? autovalidateMode;
  final List<TextInputFormatter>? inputFormatters;
  final bool readOnly; // <-- NUEVA PROPIEDAD

  const ProfileTextField({
    super.key,
    required this.label,
    required this.controller,
    required this.hintText,
    this.icon = Icons.person,
    this.keyboardType,
    this.validator,
    this.autovalidateMode,
    this.inputFormatters,
    this.readOnly = false, // <-- VALOR POR DEFECTO
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
          keyboardType: keyboardType,
          validator: validator,
          autovalidateMode: autovalidateMode,
          inputFormatters: inputFormatters,
          readOnly: readOnly, // <-- SE APLICA AQUÍ
          style: TextStyle(
            color: readOnly ? colors.onSurface.withOpacity(0.6) : colors.onSurface,
          ),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: readOnly ? colors.outline : colors.primary),
            hintText: hintText,
            hintStyle: theme.textTheme.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
            filled: true,
            fillColor: readOnly ? colors.surfaceVariant.withOpacity(0.3) : null, // Fondo diferente si es readOnly
          ),
        ),
      ],
    );
  }
}