import 'package:flutter/material.dart';

enum FieldType { text, dropdown }

class PurchaseFormField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final FieldType fieldType;
  final List<String>? dropdownItems;
  final String? dropdownValue;
  final Function(String?)? onDropdownChanged;
  final TextInputType? keyboardType;
  final VoidCallback? onTap;
  final bool readOnly;

  const PurchaseFormField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.fieldType = FieldType.text,
    this.dropdownItems,
    this.dropdownValue,
    this.onDropdownChanged,
    this.keyboardType,
    this.onTap,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
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
          if (fieldType == FieldType.text)
            TextFormField(
              controller: controller,
              keyboardType: keyboardType,
              readOnly: readOnly,
              onTap: onTap,
              decoration: InputDecoration(hintText: hint),
            )
          else
            DropdownButtonFormField<String>(
              value: dropdownValue,
              hint: Text(hint ?? ''),
              items: dropdownItems?.map((String item) {
                return DropdownMenuItem<String>(value: item, child: Text(item));
              }).toList(),
              onChanged: onDropdownChanged,
              decoration: const InputDecoration(),
            ),
        ],
      ),
    );
  }
}