import 'package:bienestar_integral_app/features/auth/presentation/widgets/custom_button.dart';
import 'package:bienestar_integral_app/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

class VerificationField extends StatelessWidget {
  final String label;
  final String hint;
  final IconData icon;
  final TextEditingController? controller;
  final VoidCallback onVerify;
  final bool isVerified;
  final TextInputType? keyboardType;

  const VerificationField({
    super.key,
    required this.label,
    required this.hint,
    required this.icon,
    required this.onVerify,
    this.controller,
    this.isVerified = false,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          label: label,
          icon: icon,
          controller: controller,
          keyboardType: keyboardType,
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: onVerify,
            child: Text(isVerified ? 'Verificado ✓' : 'Verificar'),
          ),
        ),
      ],
    );
  }
}