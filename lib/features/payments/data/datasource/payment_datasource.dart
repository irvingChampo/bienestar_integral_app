import 'dart:convert';
import 'package:bienestar_integral_app/core/error/exception.dart';
import 'package:bienestar_integral_app/core/network/http_client.dart';
import 'package:bienestar_integral_app/features/payments/data/models/payment_intent_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

abstract class PaymentDatasource {
  Future<PaymentIntentModel> createPaymentIntent({
    required int kitchenId,
    required double amount,
    String? description,
  });
}

class PaymentDatasourceImpl implements PaymentDatasource {
  final http.Client client;

  PaymentDatasourceImpl({http.Client? client})
      : client = client ?? HttpClient().client;

  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');
    if (token == null) {
      throw ServerException('Token de autenticación no encontrado.');
    }
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  @override
  Future<PaymentIntentModel> createPaymentIntent({
    required int kitchenId,
    required double amount,
    String? description,
  }) async {
    var apiUrl = dotenv.env['API_URL'];

    if (apiUrl == null || apiUrl.isEmpty) {
      throw ServerException('La variable API_URL no se encontró en el archivo .env');
    }

    // Aseguramos que no haya doble slash
    if (apiUrl.endsWith('/')) {
      apiUrl = apiUrl.substring(0, apiUrl.length - 1);
    }

    // Construcción de la URL basada estrictamente en tu JSON
    final url = Uri.parse('$apiUrl/payments/$kitchenId/create-intent');

    // Imprimimos para que puedas mostrarle la evidencia a tu Backend Dev
    debugPrint('--------------------------------------------------');
    debugPrint('🚀 INTENTANDO PAGO A: $url');
    debugPrint('--------------------------------------------------');

    try {
      final headers = await _getHeaders();
      final body = json.encode({
        'amount': amount,
        'currency': 'mxn',
        'description': description ?? 'Donación a cocina comunitaria',
      });

      final response = await client.post(url, headers: headers, body: body);

      debugPrint('📡 STATUS: ${response.statusCode}');
      debugPrint('📡 BODY: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        if (jsonResponse['success'] == true && jsonResponse['data'] != null) {
          return PaymentIntentModel.fromJson(jsonResponse['data']);
        } else {
          throw ServerException('El servidor no devolvió una URL válida.');
        }
      } else if (response.statusCode == 404) {
        // Mensaje específico para ayudar a depurar con el equipo de backend
        throw ServerException('Ruta no encontrada en el Gateway (404). Verifica que "/payments" esté mapeado.');
      } else {
        final errorDecode = json.decode(response.body);
        throw ServerException(errorDecode['message'] ?? 'Error al procesar la donación.');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      debugPrint('Error crítico: $e');
      throw NetworkException('Error de conexión con el servidor.');
    }
  }
}