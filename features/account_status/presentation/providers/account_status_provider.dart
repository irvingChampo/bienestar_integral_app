import 'package:bienestar_integral_app/core/error/exception.dart';
import 'package:bienestar_integral_app/features/account_status/data/datasource/account_status_datasource.dart';
import 'package:bienestar_integral_app/features/account_status/data/repository/account_status_repository_impl.dart';
import 'package:bienestar_integral_app/features/account_status/domain/entities/balance.dart';
import 'package:bienestar_integral_app/features/account_status/domain/entities/transaction.dart';
import 'package:bienestar_integral_app/features/account_status/domain/usecase/get_account_balance.dart';
import 'package:bienestar_integral_app/features/account_status/domain/usecase/get_payment_history.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

enum AccountStatusState { initial, loading, success, error }

class AccountStatusProvider extends ChangeNotifier {
  late final GetAccountBalance _getBalance;
  late final GetPaymentHistory _getHistory;

  AccountStatusState _status = AccountStatusState.initial;
  String? _errorMessage;

  Balance? _balance;
  List<Transaction> _transactions = [];

  AccountStatusProvider() {
    final datasource = AccountStatusDatasourceImpl(client: http.Client());
    final repository = AccountStatusRepositoryImpl(datasource: datasource);
    _getBalance = GetAccountBalance(repository);
    _getHistory = GetPaymentHistory(repository);
  }

  AccountStatusState get status => _status;
  String? get errorMessage => _errorMessage;
  Balance? get balance => _balance;
  List<Transaction> get transactions => _transactions;

  Future<void> loadData() async {
    _status = AccountStatusState.loading;
    _errorMessage = null;
    notifyListeners();

    try {

      final results = await Future.wait([
        _getBalance(),
        _getHistory(),
      ]);

      _balance = results[0] as Balance;
      _transactions = results[1] as List<Transaction>;

      _status = AccountStatusState.success;
    } on ServerException catch (e) {
      _errorMessage = e.message;
      _status = AccountStatusState.error;
    } on NetworkException catch (e) {
      _errorMessage = e.message;
      _status = AccountStatusState.error;
    } catch (e) {
      _errorMessage = 'Error inesperado al cargar el estado de cuenta.';
      _status = AccountStatusState.error;
    }
    notifyListeners();
  }
}