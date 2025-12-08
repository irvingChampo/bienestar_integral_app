import 'package:bienestar_integral_app/features/account_status/domain/entities/transaction.dart';
import 'package:bienestar_integral_app/features/account_status/domain/repository/account_status_repository.dart';

class GetPaymentHistory {
  final AccountStatusRepository repository;
  GetPaymentHistory(this.repository);
  Future<List<Transaction>> call() async => await repository.getHistory();
}