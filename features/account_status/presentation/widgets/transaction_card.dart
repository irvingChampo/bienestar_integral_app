import 'package:bienestar_integral_app/features/account_status/domain/entities/transaction.dart';
import 'package:flutter/material.dart';

class TransactionCard extends StatelessWidget {
  final Transaction transaction;

  const TransactionCard({
    super.key,
    required this.transaction,
  });

  Color _getStatusColor(String status, ColorScheme colors) {
    if (status.toLowerCase().contains('exitoso')) return Colors.green;
    if (status.toLowerCase().contains('procesando')) return Colors.orange;
    return colors.error;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    final isIncome = transaction.tipo == 'Donación' || transaction.tipo == 'Ingreso';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colors.outline.withOpacity(0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(transaction.concepto, style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(
                        '${transaction.fecha} · ${transaction.donador.fullName}',
                        style: textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
                Text(
                  isIncome ? '+${transaction.monto}' : '-${transaction.monto}',
                  style: textTheme.titleMedium?.copyWith(
                    color: isIncome ? Colors.green : colors.error,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Divider(),
            Row(
              children: [
                Text('Estado: ', style: textTheme.bodySmall),
                Text(
                  transaction.estado,
                  style: textTheme.bodySmall?.copyWith(
                    color: _getStatusColor(transaction.estado, colors),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}