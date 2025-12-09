import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
class RegisterLink extends StatelessWidget {
  final VoidCallback onTap;
  const RegisterLink({super.key, required this.onTap});
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return RichText(
      text: TextSpan(
        style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
        children: [
          const TextSpan(text: '¿No tienes cuenta? '),
          TextSpan(
            text: 'Regístrate',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
            recognizer: TapGestureRecognizer()..onTap = onTap,
          ),
        ],
      ),
    );
  }
}