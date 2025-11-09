import 'package:flutter/material.dart';

class CurrentBalanceCard extends StatelessWidget {
  final String amount;

  const CurrentBalanceCard({
    super.key,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      elevation: 2,
      shadowColor: colors.shadow.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          children: [
            Text(
              'Dinero Actual',
              style: textTheme.titleMedium?.copyWith(color: colors.onSurface),
            ),
            const SizedBox(height: 8),
            Text(
              amount,
              style: textTheme.headlineMedium?.copyWith(color: colors.primary, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}