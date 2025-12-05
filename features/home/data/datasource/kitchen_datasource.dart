import 'dart:convert';
import 'package:bienestar_integral_app/core/error/exception.dart';
import 'package:bienestar_integral_app/core/network/http_client.dart';
import 'package:bienestar_integral_app/features/home/data/models/kitchen_detail_model.dart';
import 'package:bienestar_integral_app/features/home/data/models/kitchen_model.dart';
import 'package:bienestar_integral_app/features/home/data/models/kitchen_subscription_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

abstract class KitchenDatasource {
  Future<List<KitchenModel>> getNearbyKitchens();
  Future<KitchenDetailModel> getKitchenDetails(int kitchenId);
  Future<void> subscribeToKitchen(int kitchenId);
  Future<void> unsubscribeFromKitchen(int kitchenId);
  Future<List<int>> getSubscribedKitchenIds();
  Future<List<KitchenSubscriptionModel>> getMyKitchenSubscriptions();
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

  // ... (MÉTODOS EXISTENTES getNearbyKitchens, getKitchenDetails, subscribeToKitchen, getSubscribedKitchenIds, getMyKitchenSubscriptions SE MANTIENEN IGUAL) ...
  // Asegúrate de copiar el resto de métodos que ya funcionaban. Aquí solo muestro el archivo con la estructura y el cambio específico.

  @override
  Future<List<KitchenModel>> getNearbyKitchens() async {
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

  @override
  Future<void> subscribeToKitchen(int kitchenId) async {
    var apiUrl = dotenv.env['API_URL'];
    if (apiUrl == null) throw ServerException('API_URL no encontrada');
    if (apiUrl.endsWith('/')) apiUrl = apiUrl.substring(0, apiUrl.length - 1);
    final url = Uri.parse('$apiUrl/kitchens/$kitchenId/subscribe');
    try {
      final headers = await _getHeaders();
      final response = await client.post(url, headers: headers);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['success'] != true) throw ServerException(jsonResponse['message']);
      } else {
        throw ServerException('Error al suscribirse');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Error de conexión');
    }
  }

  // --- MÉTODOS DE CONSULTA DE SUSCRIPCIONES ---
  @override
  Future<List<int>> getSubscribedKitchenIds() async {
    var apiUrl = dotenv.env['API_URL'];
    if (apiUrl == null) throw ServerException('API_URL no encontrada');
    if (apiUrl.endsWith('/')) apiUrl = apiUrl.substring(0, apiUrl.length - 1);
    final url = Uri.parse('$apiUrl/kitchens/subscribed/me');
    try {
      final headers = await _getHeaders();
      final response = await client.get(url, headers: headers);
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> data = jsonResponse['data'];
        return data.map<int>((item) {
          if (item['kitchen'] != null && item['kitchen']['id'] != null) {
            return item['kitchen']['id'] as int;
          } else if (item['kitchenId'] != null) {
            return item['kitchenId'] as int;
          }
          return 0;
        }).toList();
      } else {
        throw ServerException('Error al obtener suscripciones');
      }
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<KitchenSubscriptionModel>> getMyKitchenSubscriptions() async {
    var apiUrl = dotenv.env['API_URL'];
    if (apiUrl == null) throw ServerException('API_URL no encontrada');
    if (apiUrl.endsWith('/')) apiUrl = apiUrl.substring(0, apiUrl.length - 1);
    final url = Uri.parse('$apiUrl/kitchens/subscribed/me');
    try {
      final headers = await _getHeaders();
      final response = await client.get(url, headers: headers);
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> data = jsonResponse['data'];
        return data.map((json) => KitchenSubscriptionModel.fromJson(json)).toList();
      } else {
        throw ServerException('Error al obtener mis cocinas');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Error de red al obtener mis cocinas');
    }
  }

  // --- MÉTODOS CORREGIDO: DESUSCRIPCIÓN ---
  @override
  Future<void> unsubscribeFromKitchen(int kitchenId) async {
    var apiUrl = dotenv.env['API_URL'];
    if (apiUrl == null || apiUrl.isEmpty) {
      throw ServerException('La variable API_URL no se encontró en el archivo .env');
    }
    // Limpieza de URL base
    if (apiUrl.endsWith('/')) {
      apiUrl = apiUrl.substring(0, apiUrl.length - 1);
    }

    // Endpoint: DELETE /api/v1/kitchens/:id/subscribe
    final url = Uri.parse('$apiUrl/kitchens/$kitchenId/subscribe');

    debugPrint('--------------------------------------------------');
    debugPrint('🚀 INTENTANDO DESUSCRIPCIÓN (DELETE): $url');
    debugPrint('--------------------------------------------------');

    try {
      final headers = await _getHeaders();
      final response = await client.delete(url, headers: headers);

      debugPrint('📡 STATUS: ${response.statusCode}');
      debugPrint('📡 BODY: ${response.body}');

      if (response.statusCode == 200) {
        // Parseamos el cuerpo JSON según tu especificación
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        if (jsonResponse['success'] == true) {
          // Éxito confirmado por el backend
          return;
        } else {
          throw ServerException(jsonResponse['message'] ?? 'No se pudo cancelar la suscripción.');
        }
      } else if (response.statusCode == 404) {
        throw ServerException('No se encontró la suscripción o la ruta es incorrecta (404).');
      } else {
        final errorDecode = json.decode(response.body);
        throw ServerException(errorDecode['message'] ?? 'Error desconocido al cancelar suscripción.');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      debugPrint('Error crítico en unsubscribeFromKitchen: $e');
      throw NetworkException('Error de conexión al intentar cancelar suscripción.');
    }
  }
}