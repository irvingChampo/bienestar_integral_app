import 'package:bienestar_integral_app/features/account_status/domain/entities/balance.dart';
import 'package:bienestar_integral_app/features/account_status/domain/repository/account_status_repository.dart';

class GetAccountBalance {
  final AccountStatusRepository repository;
  GetAccountBalance(this.repository);
  Future<Balance> call() async => await repository.getBalance();
}