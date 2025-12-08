import 'package:bienestar_integral_app/features/account_status/presentation/widgets/current_balance_card.dart';
import 'package:bienestar_integral_app/features/account_status/presentation/widgets/transaction_card.dart';
import 'package:bienestar_integral_app/features/settings/presentation/widgets/home_app_bar.dart';
import 'package:flutter/material.dart';

class AccountStatusScreen extends StatelessWidget {
  const AccountStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: const HomeAppBar(title: 'Estado de Cuenta', showBackButton: true),
      body: ListView(
        children: [
          const SizedBox(height: 12),
          const CurrentBalanceCard(amount: '\$12,450.00 MXN'),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
            child: Text(
              'Historial de movimientos',
              style: textTheme.titleLarge?.copyWith(color: colors.onBackground),
            ),
          ),
          const TransactionCard(
            title: 'Compra insumos',
            date: '19 oct 2025',
            source: 'Tienda local',
            amount: '\$35.50',
            isExpense: true,
          ),
          const TransactionCard(
            title: 'Donación Recibida',
            date: '20 oct 2025',
            source: 'Plataforma',
            amount: '\$250.00',
            isExpense: false,
          ),
        ],
      ),
    );
  }
}