import 'package:flutter/material.dart';

class CustomCheckbox extends StatelessWidget {
  final String label;
  final bool value;
  final Function(bool?) onChanged;
  final bool isTerms;

  const CustomCheckbox({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.isTerms = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.circular(8),
      child: Row(
        children: [
          Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: colors.primary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            // CAMBIO: Se usa el color `outline` del tema.
            side: BorderSide(color: colors.outline.withOpacity(0.7), width: 1.5), // ANTES: Colors.grey.shade400
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}