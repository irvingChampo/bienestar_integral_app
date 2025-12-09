import 'package:flutter/material.dart';

class IngredientsInputCard extends StatelessWidget {
  const IngredientsInputCard({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 2,
      shadowColor: colors.shadow.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '¿Qué ingredientes tienes?',
              style: textTheme.titleMedium?.copyWith(
                color: colors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              maxLines: 6,
              decoration: const InputDecoration(
                hintText: 'Ej. pollo, arroz, zanahorias...',
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Lógica para llamar a la IA y generar la receta
                },
                child: const Text('Generar Receta'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}