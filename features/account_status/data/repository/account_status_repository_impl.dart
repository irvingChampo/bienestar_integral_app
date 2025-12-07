import 'package:bienestar_integral_app/features/account_status/data/datasource/account_status_datasource.dart';
import 'package:bienestar_integral_app/features/account_status/domain/entities/balance.dart';
import 'package:bienestar_integral_app/features/account_status/domain/entities/transaction.dart';
import 'package:bienestar_integral_app/features/account_status/domain/repository/account_status_repository.dart';

class AccountStatusRepositoryImpl implements AccountStatusRepository {
  final AccountStatusDatasource datasource;

  AccountStatusRepositoryImpl({required this.datasource});

  @override
  Future<Balance> getBalance() async {
    return await datasource.getBalance();
  }

  @override
  Future<List<Transaction>> getHistory() async {
    return await datasource.getHistory();
  }
}