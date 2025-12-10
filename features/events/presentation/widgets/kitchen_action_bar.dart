import 'package:flutter/material.dart';

class KitchenActionBar extends StatelessWidget {
  final VoidCallback onDonate;
  final VoidCallback onSubscribe;
  final bool isSubscribed;
  final bool isLoading;

  const KitchenActionBar({
    super.key,
    required this.onDonate,
    required this.onSubscribe,
    required this.isSubscribed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Color amarillo suavizado para modo oscuro
    final primarySoft = isDark ? colors.primary.withOpacity(0.8) : colors.primary;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          // Botón Donar (Outline)
          Expanded(
            child: OutlinedButton.icon(
              onPressed: isLoading ? null : onDonate,
              style: OutlinedButton.styleFrom(
                foregroundColor: primarySoft,
                side: BorderSide(color: primarySoft, width: 2),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              icon: Icon(Icons.volunteer_activism, size: 20, color: primarySoft),
              label: const Text(
                'Donar',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Botón Inscribirse / Cancelar (Sólido)
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: isSubscribed
                        ? colors.error.withOpacity(0.3)
                        : colors.primary.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                onPressed: isLoading ? null : onSubscribe,
                style: ElevatedButton.styleFrom(
                  // Usamos el amarillo suavizado (primarySoft) si no está suscrito
                  backgroundColor: isSubscribed ? colors.error : primarySoft,

                  foregroundColor: isSubscribed ? colors.onError : colors.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                ),
                icon: isLoading
                    ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: isSubscribed ? colors.onError : colors.onPrimary
                    )
                )
                    : Icon(isSubscribed ? Icons.exit_to_app : Icons.edit_note, size: 20),
                label: Text(
                  isSubscribed ? 'Cancelar' : 'Inscribirse',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}