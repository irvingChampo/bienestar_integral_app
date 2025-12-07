import 'dart:convert';
import 'package:bienestar_integral_app/core/error/exception.dart';
import 'package:bienestar_integral_app/core/network/http_client.dart';
import 'package:bienestar_integral_app/features/account_status/data/models/balance_model.dart';
import 'package:bienestar_integral_app/features/account_status/data/models/transaction_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

abstract class AccountStatusDatasource {
  Future<BalanceModel> getBalance();
  Future<List<TransactionModel>> getHistory();
}

class AccountStatusDatasourceImpl implements AccountStatusDatasource {
  final http.Client client;
  final String? _apiUrl = dotenv.env['API_URL'];

  AccountStatusDatasourceImpl({http.Client? client})
      : client = client ?? HttpClient().client;

  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');
    if (token == null) throw ServerException('Token no encontrado');
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  @override
  Future<BalanceModel> getBalance() async {
    final url = Uri.parse('$_apiUrl/payments/balance');
    try {
      final response = await client.get(url, headers: await _getHeaders());

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['success'] == true) {
          return BalanceModel.fromJson(jsonResponse['data']);
        }
      }
      throw ServerException('Error al obtener balance');
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Error de conexión al obtener balance');
    }
  }

  @override
  Future<List<TransactionModel>> getHistory() async {
    final url = Uri.parse('$_apiUrl/payments/history');
    try {
      final response = await client.get(url, headers: await _getHeaders());

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['success'] == true) {
          final List<dynamic> list = jsonResponse['data'];
          return list.map((e) => TransactionModel.fromJson(e)).toList();
        }
      }
      throw ServerException('Error al obtener historial');
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Error de conexión al obtener historial');
    }
  }
}