import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    // Se obtiene el colorScheme del tema actual.
    final colors = Theme.of(context).colorScheme;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? SizedBox(
          height: 24,
          width: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            // CAMBIO: Se usa el color `onPrimary` del tema.
            valueColor: AlwaysStoppedAnimation<Color>(colors.onPrimary), // ANTES: Colors.white
          ),
        )
            : Text(text),
      ),
    );
  }
}