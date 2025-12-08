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
  Future<KitchenDetailModel> getMyKitchen();
  Future<List<ScheduleModel>> getKitchenSchedules(int kitchenId); // <-- NUEVO
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

  String _getApiUrl() {
    var apiUrl = dotenv.env['API_URL'];
    if (apiUrl == null) throw ServerException('API_URL no encontrada en .env');
    if (apiUrl.endsWith('/')) apiUrl = apiUrl.substring(0, apiUrl.length - 1);
    return apiUrl;
  }

  // --- MÉTODOS EXISTENTES ---

  @override
  Future<List<KitchenModel>> getNearbyKitchens() async {
    final apiUrl = _getApiUrl();
    final url = Uri.parse('$apiUrl/kitchens/nearby');
    try {
      final headers = await _getHeaders();
      final response = await client.get(url, headers: headers);
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> data = jsonResponse['data'];
        return data.map((json) => KitchenModel.fromJson(json)).toList();
      } else {
        throw ServerException('Error al obtener cocinas cercanas');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Error de conexión');
    }
  }

  @override
  Future<KitchenDetailModel> getKitchenDetails(int kitchenId) async {
    final apiUrl = _getApiUrl();
    final url = Uri.parse('$apiUrl/kitchens/$kitchenId');
    // debugPrint('🚀 [STEP 2] GET DETAILS: $url');
    try {
      final headers = await _getHeaders();
      final response = await client.get(url, headers: headers);
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        // OJO: Este endpoint NO trae horarios, pero trae el resto de info
        return KitchenDetailModel.fromJson(jsonResponse['data']);
      } else {
        throw ServerException('Error al obtener detalles');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Error de conexión');
    }
  }

  @override
  Future<KitchenDetailModel> getMyKitchen() async {
    final apiUrl = _getApiUrl();
    final url = Uri.parse('$apiUrl/kitchens/me');
    // debugPrint('🚀 [STEP 1] GET ME: $url');
    try {
      final headers = await _getHeaders();
      final response = await client.get(url, headers: headers);
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final data = jsonResponse['data'];
        final adaptedJson = {"kitchen": data, "isSubscribed": false};
        return KitchenDetailModel.fromJson(adaptedJson);
      } else {
        throw ServerException('Error al obtener mi cocina (${response.statusCode})');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Error de conexión');
    }
  }

  // --- NUEVO MÉTODO CRÍTICO: OBTENER HORARIOS ---
  @override
  Future<List<ScheduleModel>> getKitchenSchedules(int kitchenId) async {
    final apiUrl = _getApiUrl();
    final url = Uri.parse('$apiUrl/kitchens/$kitchenId/schedules');

    debugPrint('🚀 [STEP 3] GET SCHEDULES: $url');

    try {
      final headers = await _getHeaders();
      final response = await client.get(url, headers: headers);

      debugPrint('📡 [STEP 3] STATUS: ${response.statusCode}');
      debugPrint('📩 [STEP 3] BODY: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> data = jsonResponse['data'];
        return data.map((json) => ScheduleModel.fromJson(json)).toList();
      } else {
        // Si no hay horarios o da error, retornamos lista vacía o lanzamos excepción
        return [];
      }
    } catch (e) {
      debugPrint('Error obteniendo horarios: $e');
      return [];
    }
  }

  // --- MÉTODOS RESTANTES (Placeholders requeridos) ---
  @override
  Future<void> subscribeToKitchen(int kitchenId) async {
    // ... (Implementación existente)
    final apiUrl = _getApiUrl();
    await client.post(Uri.parse('$apiUrl/kitchens/$kitchenId/subscribe'), headers: await _getHeaders());
  }
  @override
  Future<void> unsubscribeFromKitchen(int kitchenId) async {
    final apiUrl = _getApiUrl();
    await client.delete(Uri.parse('$apiUrl/kitchens/$kitchenId/subscribe'), headers: await _getHeaders());
  }
  @override
  Future<List<int>> getSubscribedKitchenIds() async { return []; } // Simplificado para este paso
  @override
  Future<List<KitchenSubscriptionModel>> getMyKitchenSubscriptions() async { return []; } // Simplificado
}