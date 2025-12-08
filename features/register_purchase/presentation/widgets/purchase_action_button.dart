import 'package:flutter/material.dart';

class PurchaseActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isPrimary;

  const PurchaseActionButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isPrimary = true,
  });

  @override
  Widget build(BuildContext context) {
    if (isPrimary) {
      return Expanded(
        child: ElevatedButton(
          onPressed: onPressed,
          child: Text(label),
        ),
      );
    }
    return Expanded(
      child: OutlinedButton(
        onPressed: onPressed,
        child: Text(label),
      ),
    );
  }
}