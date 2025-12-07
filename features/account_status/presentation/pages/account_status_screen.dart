import 'package:bienestar_integral_app/features/account_status/presentation/providers/account_status_provider.dart';
import 'package:bienestar_integral_app/features/account_status/presentation/widgets/current_balance_card.dart';
import 'package:bienestar_integral_app/features/account_status/presentation/widgets/transaction_card.dart';
import 'package:bienestar_integral_app/features/settings/presentation/widgets/home_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountStatusScreen extends StatefulWidget {
  const AccountStatusScreen({super.key});

  @override
  State<AccountStatusScreen> createState() => _AccountStatusScreenState();
}

class _AccountStatusScreenState extends State<AccountStatusScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AccountStatusProvider>().loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    final provider = context.watch<AccountStatusProvider>();

    return Scaffold(
      appBar: const HomeAppBar(title: 'Estado de Cuenta', showBackButton: true),
      body: RefreshIndicator(
        onRefresh: () async => await provider.loadData(),
        child: _buildBody(provider, textTheme, colors),
      ),
    );
  }

  Widget _buildBody(
      AccountStatusProvider provider, TextTheme textTheme, ColorScheme colors) {
    if (provider.status == AccountStatusState.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.status == AccountStatusState.error) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(provider.errorMessage ?? 'Error al cargar información'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => provider.loadData(),
              child: const Text('Reintentar'),
            )
          ],
        ),
      );
    }


    final available = provider.balance?.available ?? 0.0;
    final formattedBalance = '\$${available.toStringAsFixed(2)} ${provider.balance?.currency.toUpperCase() ?? 'MXN'}';

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        const SizedBox(height: 12),
        CurrentBalanceCard(amount: formattedBalance),

        Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Historial de movimientos',
                style:
                textTheme.titleLarge?.copyWith(color: colors.onBackground),
              ),
              if (provider.transactions.isEmpty)
                Text('Sin datos', style: textTheme.bodySmall),
            ],
          ),
        ),

        if (provider.transactions.isEmpty)
          const Padding(
            padding: EdgeInsets.all(32.0),
            child: Center(child: Text('No hay movimientos registrados.')),
          )
        else
          ...provider.transactions.map((transaction) => TransactionCard(
            transaction: transaction,
          )),

        const SizedBox(height: 24),
      ],
    );
  }
}