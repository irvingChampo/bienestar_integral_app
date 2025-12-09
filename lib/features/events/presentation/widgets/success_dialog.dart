import 'package:flutter/material.dart';

class SuccessDialog extends StatelessWidget {
  final String message;
  final String buttonText;
  final VoidCallback? onClose;

  const SuccessDialog({
    super.key,
    required this.message,
    this.buttonText = 'Cerrar',
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                // CAMBIO: Se usa el color `primary` del tema en lugar de un verde hardcodeado.
                color: colors.primary.withOpacity(0.2), // ANTES: const Color(0xFF4CAF50).withOpacity(0.2)
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.check, size: 50, color: colors.primary), // ANTES: const Color(0xFF4CAF50)
            ),
            const SizedBox(height: 24),
            Text(
              message,
              style: theme.textTheme.titleMedium?.copyWith(
                color: colors.onSurface,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  if (onClose != null) onClose!();
                },
                child: Text(buttonText),
              ),
            ),
          ],
        ),
      ),
    );
  }
}