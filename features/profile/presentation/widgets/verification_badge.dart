import 'package:flutter/material.dart';

class VerificationBadge extends StatelessWidget {
  final bool isVerified;
  final VoidCallback? onTap;
  final bool isLoading;

  const VerificationBadge({
    super.key,
    required this.isVerified,
    this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Si está cargando (ej. enviando el correo), mostramos un spinner pequeño
    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.only(top: 8.0),
        child: SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    if (isVerified) {
      return Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 18),
            const SizedBox(width: 6),
            Text(
              'Verificado',
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: theme.colorScheme.error, size: 18),
          const SizedBox(width: 6),
          Text(
            'No verificado',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.error,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          TextButton(
            onPressed: onTap,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(50, 30),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'Verificar ahora',
              style: theme.textTheme.labelMedium?.copyWith(
                decoration: TextDecoration.underline,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}