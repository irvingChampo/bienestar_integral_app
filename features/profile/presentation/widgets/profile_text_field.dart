import 'package:flutter/material.dart';

class ProfileTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hintText;
  final bool isRequired;
  final IconData icon;

  const ProfileTextField({
    super.key,
    required this.label,
    required this.controller,
    required this.hintText,
    this.isRequired = true,
    this.icon = Icons.person,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.titleSmall?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: theme.colorScheme.primary),
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
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