import 'dart:convert';
import 'package:bienestar_integral_app/core/error/exception.dart';
import 'package:bienestar_integral_app/core/network/http_client.dart';
import 'package:bienestar_integral_app/features/home/data/models/kitchen_detail_model.dart';
import 'package:bienestar_integral_app/features/home/data/models/kitchen_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

abstract class KitchenDatasource {
  Future<List<KitchenModel>> getNearbyKitchens();
  Future<KitchenDetailModel> getKitchenDetails(int kitchenId);
  Future<void> subscribeToKitchen(int kitchenId);
}

class KitchenDatasourceImpl implements KitchenDatasource {
  final http.Client client;

  KitchenDatasourceImpl({http.Client? client})
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

  // ... (MÉTODOS EXISTENTES getNearbyKitchens Y getKitchenDetails SE MANTIENEN IGUAL) ...
  // Solo asegúrate de que usen dotenv.env['API_URL'] dentro del método si dan problemas.

  @override
  Future<List<KitchenModel>> getNearbyKitchens() async {
    // Implementación existente (asegura usar la lógica de dotenv aquí también si falla)
    final apiUrl = dotenv.env['API_URL'];
    if (apiUrl == null) throw ServerException('API_URL no encontrada');
    final url = Uri.parse('$apiUrl/kitchens/nearby');

    try {
      final headers = await _getHeaders();
      final response = await client.get(url, headers: headers);
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> data = jsonResponse['data'];
        return data.map((json) => KitchenModel.fromJson(json)).toList();
      } else {
        throw ServerException('Error al obtener cocinas');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Error de red');
    }
  }

  @override
  Future<KitchenDetailModel> getKitchenDetails(int kitchenId) async {
    final apiUrl = dotenv.env['API_URL'];
    if (apiUrl == null) throw ServerException('API_URL no encontrada');
    final url = Uri.parse('$apiUrl/kitchens/$kitchenId');

    try {
      final headers = await _getHeaders();
      final response = await client.get(url, headers: headers);
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return KitchenDetailModel.fromJson(jsonResponse['data']);
      } else {
        throw ServerException('Error al obtener detalles');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Error de red');
    }
  }

  // --- MÉTODO DE SUSCRIPCIÓN CON LOGS ---
  @override
  Future<void> subscribeToKitchen(int kitchenId) async {
    var apiUrl = dotenv.env['API_URL'];

    if (apiUrl == null || apiUrl.isEmpty) {
      throw ServerException('La variable API_URL no se encontró en el archivo .env');
    }

    // Limpieza de URL base
    if (apiUrl.endsWith('/')) {
      apiUrl = apiUrl.substring(0, apiUrl.length - 1);
    }

    final url = Uri.parse('$apiUrl/kitchens/$kitchenId/subscribe');

    debugPrint('--------------------------------------------------');
    debugPrint('🚀 INTENTANDO SUSCRIPCIÓN A: $url');
    debugPrint('--------------------------------------------------');

    try {
      final headers = await _getHeaders();

      // POST sin body
      final response = await client.post(url, headers: headers);

      debugPrint('📡 STATUS: ${response.statusCode}');
      debugPrint('📡 BODY: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        if (jsonResponse['success'] != true) {
          // Si success es false, lanzamos el mensaje que venga del server
          throw ServerException(jsonResponse['message'] ?? 'No se pudo completar la suscripción.');
        }
      } else if (response.statusCode == 404) {
        throw ServerException('Endpoint no encontrado (404). Verifica la ruta.');
      } else if (response.statusCode == 400 || response.statusCode == 409) {
        // Errores de lógica (ej. ya suscrito)
        final errorDecode = json.decode(response.body);
        throw ServerException(errorDecode['message'] ?? 'No se pudo suscribir (Error ${response.statusCode}).');
      } else {
        final errorDecode = json.decode(response.body);
        throw ServerException(errorDecode['message'] ?? 'Error desconocido del servidor.');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      debugPrint('Error crítico en subscribeToKitchen: $e');
      throw NetworkException('Error de conexión al intentar suscribirse.');
    }
  }
}