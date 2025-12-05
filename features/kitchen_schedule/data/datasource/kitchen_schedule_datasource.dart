import 'dart:convert';
import 'package:bienestar_integral_app/core/error/exception.dart';
import 'package:bienestar_integral_app/core/network/http_client.dart';
import 'package:flutter/foundation.dart'; // Necesario para debugPrint
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

abstract class KitchenScheduleDatasource {
  Future<void> createSchedules({
    required int kitchenId,
    required String weekStart,
    required String weekEnd,
    required String weekendStart,
    required String weekendEnd,
  });
}

class KitchenScheduleDatasourceImpl implements KitchenScheduleDatasource {
  final http.Client client;
  final String? _apiUrl = dotenv.env['API_URL'];

  KitchenScheduleDatasourceImpl({http.Client? client})
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
  Future<void> createSchedules({
    required int kitchenId,
    required String weekStart,
    required String weekEnd,
    required String weekendStart,
    required String weekendEnd,
  }) async {
    // 1. Construcción de URL
    var baseUrl = _apiUrl;
    if (baseUrl != null && baseUrl.endsWith('/')) {
      baseUrl = baseUrl.substring(0, baseUrl.length - 1);
    }
    final url = Uri.parse('$baseUrl/kitchens/$kitchenId/schedules');

    // 2. Construcción del Body (JSON)
    // Nos aseguramos de respetar la estructura: weekdays y weekend
    final bodyMap = {
      "weekdays": {
        "startTime": weekStart,
        "endTime": weekEnd
      },
      "weekend": {
        "startTime": weekendStart,
        "endTime": weekendEnd
      }
    };
    final bodyJson = json.encode(bodyMap);

    // --- 🚨 INICIO DE LOGS DE DEPURACIÓN 🚨 ---
    debugPrint('\n🔵 ================== REQUEST LOG ==================');
    debugPrint('📍 URL: $url');
    debugPrint('📦 BODY (Lo que enviamos):');
    debugPrint(bodyJson);
    // Tip: Copia el resultado de bodyJson y pégalo en un validador JSON si dudas
    debugPrint('🔵 =================================================\n');
    // --- FIN DE LOGS ---

    try {
      final headers = await _getHeaders();

      // Enviamos la petición
      final response = await client.post(url, headers: headers, body: bodyJson);

      // --- 🚨 LOGS DE RESPUESTA 🚨 ---
      debugPrint('\n🟠 ================== RESPONSE LOG ==================');
      debugPrint('📡 STATUS: ${response.statusCode}');
      debugPrint('📩 RESPONSE BODY (Lo que respondió el server):');
      debugPrint(response.body);
      debugPrint('🟠 ==================================================\n');
      // --- FIN DE LOGS ---

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['success'] != true) {
          throw ServerException(jsonResponse['message'] ?? 'Error al crear horarios');
        }
      } else {
        // Intentamos decodificar el error para mostrarlo en pantalla
        String errorMessage = 'Error del servidor (${response.statusCode})';
        try {
          final errorDecode = json.decode(response.body);
          if (errorDecode['message'] != null) {
            errorMessage = errorDecode['message']; // Aquí suele venir la razón del 400
          }
        } catch (_) {}

        throw ServerException(errorMessage);
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      // Log extra por si falla la conexión
      debugPrint('🔴 ERROR DE CONEXIÓN: $e');
      throw NetworkException('Error de conexión al crear horarios');
    }
  }
}