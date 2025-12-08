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
  Future<List<ScheduleModel>> getKitchenSchedules(int kitchenId);
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
      throw NetworkException('Error de conexión');
    }
  }

  @override
  Future<KitchenDetailModel> getMyKitchen() async {
    final apiUrl = _getApiUrl();
    final url = Uri.parse('$apiUrl/kitchens/me');
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

  @override
  Future<List<ScheduleModel>> getKitchenSchedules(int kitchenId) async {
    final apiUrl = _getApiUrl();
    final url = Uri.parse('$apiUrl/kitchens/$kitchenId/schedules');

    try {
      final headers = await _getHeaders();
      final response = await client.get(url, headers: headers);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> data = jsonResponse['data'];
        return data.map((json) => ScheduleModel.fromJson(json)).toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> subscribeToKitchen(int kitchenId) async {
    final apiUrl = _getApiUrl();
    // Endpoint basado en tu JSON: /api/v1/kitchens/:id/subscribe
    final url = Uri.parse('$apiUrl/kitchens/$kitchenId/subscribe');
    try {
      final response = await client.post(url, headers: await _getHeaders());
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ServerException('Error al suscribirse a la cocina');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Error de conexión al suscribirse');
    }
  }

  @override
  Future<void> unsubscribeFromKitchen(int kitchenId) async {
    final apiUrl = _getApiUrl();
    final url = Uri.parse('$apiUrl/kitchens/$kitchenId/subscribe');
    try {
      final response = await client.delete(url, headers: await _getHeaders());
      if (response.statusCode != 200) {
        throw ServerException('Error al desuscribirse de la cocina');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Error de conexión al desuscribirse');
    }
  }

  // --- AQUÍ ESTÁN LAS CORRECCIONES BASADAS EN TU JSON ---

  @override
  Future<List<KitchenSubscriptionModel>> getMyKitchenSubscriptions() async {
    final apiUrl = _getApiUrl();

    // CORRECCIÓN: Usamos la URL exacta que me pasaste en el JSON
    // url: "http://localhost:3000/api/v1/kitchens/subscribed/me"
    final url = Uri.parse('$apiUrl/kitchens/subscribed/me');

    try {
      final headers = await _getHeaders();
      final response = await client.get(url, headers: headers);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        // Verificamos success y data
        if (jsonResponse['success'] == true && jsonResponse['data'] != null) {
          final List<dynamic> data = jsonResponse['data'];
          return data.map((json) => KitchenSubscriptionModel.fromJson(json)).toList();
        }
        return [];
      } else {
        throw ServerException('Error al obtener suscripciones (Status: ${response.statusCode})');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Error de conexión al cargar mis cocinas');
    }
  }

  @override
  Future<List<int>> getSubscribedKitchenIds() async {
    // Reutilizamos el método corregido arriba para obtener solo los IDs
    try {
      final subscriptions = await getMyKitchenSubscriptions();
      return subscriptions.map((sub) => sub.kitchen.id).toList();
    } catch (e) {
      return [];
    }
  }
}