import 'package:bienestar_integral_app/features/account_status/domain/entities/balance.dart';
import 'package:bienestar_integral_app/features/account_status/domain/entities/transaction.dart';

abstract class AccountStatusRepository {
  Future<Balance> getBalance();
  Future<List<Transaction>> getHistory();
}