import 'dart:convert';
import 'package:bienestar_integral_app/core/error/exception.dart';
import 'package:bienestar_integral_app/core/network/http_client.dart';
import 'package:bienestar_integral_app/features/events/data/models/event_model.dart';
import 'package:bienestar_integral_app/features/events/data/models/event_registration_model.dart';
import 'package:flutter/foundation.dart'; // Para debugPrint
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

abstract class EventDatasource {
  Future<List<EventModel>> getEventsByKitchen(int kitchenId);
  Future<void> registerToEvent(int eventId);
  Future<List<EventRegistrationModel>> getMyRegistrations();
  Future<void> unregisterFromEvent(int eventId);
}

class EventDatasourceImpl implements EventDatasource {
  final http.Client client;

  EventDatasourceImpl({http.Client? client})
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
      'Accept-Encoding': 'identity',
    };
  }

  String _getApiUrl() {
    var apiUrl = dotenv.env['API_URL'];
    if (apiUrl == null || apiUrl.isEmpty) {
      throw ServerException('La variable API_URL no se encontró en el archivo .env');
    }
    if (apiUrl.endsWith('/')) {
      apiUrl = apiUrl.substring(0, apiUrl.length - 1);
    }
    return apiUrl;
  }

  @override
  Future<List<EventModel>> getEventsByKitchen(int kitchenId) async {
    final apiUrl = _getApiUrl();
    final url = Uri.parse('$apiUrl/events/kitchen/$kitchenId');

    // --- LOG 1: Verificamos la URL exacta ---
    debugPrint('🔵 [GET] Solicitando eventos a: $url');

    try {
      final headers = await _getHeaders();
      final response = await client.get(url, headers: headers);

      // --- LOG 2: Vemos qué respondió el servidor ---
      debugPrint('🔵 [RESPONSE] Status Code: ${response.statusCode}');
      debugPrint('🔵 [RESPONSE] Body: ${response.body}');

      if (response.statusCode == 200) {
        // Intentamos decodificar
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        // --- LOG 3: Verificamos la estructura 'data' ---
        if (jsonResponse['data'] == null) {
          debugPrint('🔴 [ERROR] El campo "data" es null');
          return [];
        }

        final List<dynamic> data = jsonResponse['data'];
        debugPrint('🟢 [SUCCESS] Se encontraron ${data.length} eventos.');

        // Intentamos convertir a modelos
        try {
          return data.map((json) => EventModel.fromJson(json)).toList();
        } catch (e) {
          debugPrint('🔴 [ERROR PARSING] Falló la conversión de JSON a EventModel: $e');
          // Esto nos dirá si un campo cambió de nombre o tipo
          throw ServerException('Error al procesar los datos de eventos.');
        }
      } else {
        debugPrint('🔴 [ERROR SERVER] ${response.body}');
        throw ServerException('Error al obtener eventos de la cocina (${response.statusCode})');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      debugPrint('🔴 [EXCEPTION] $e');
      throw NetworkException('Error de red al obtener eventos');
    }
  }

  // ... (MANTÉN LOS DEMÁS MÉTODOS IGUAL QUE ANTES: registerToEvent, getMyRegistrations, unregisterFromEvent)
  @override
  Future<void> registerToEvent(int eventId) async {
    final apiUrl = _getApiUrl();
    final url = Uri.parse('$apiUrl/event-registrations/$eventId/register');
    try {
      final headers = await _getHeaders();
      final response = await client.post(url, headers: headers);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['success'] != true) {
          throw ServerException(jsonResponse['message'] ?? 'Error al inscribirse');
        }
      } else {
        try {
          final errorDecode = json.decode(response.body);
          throw ServerException(errorDecode['message'] ?? 'Error al inscribirse (Código ${response.statusCode})');
        } catch (_) {
          throw ServerException('Error al inscribirse (Código ${response.statusCode})');
        }
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Error de conexión al inscribirse');
    }
  }

  @override
  Future<List<EventRegistrationModel>> getMyRegistrations() async {
    final apiUrl = _getApiUrl();
    final url = Uri.parse('$apiUrl/event-registrations/my-registrations');
    try {
      final headers = await _getHeaders();
      final response = await client.get(url, headers: headers);
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> data = jsonResponse['data'];
        return data.map((json) => EventRegistrationModel.fromJson(json)).toList();
      } else {
        throw ServerException('Error al obtener mis inscripciones');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Error de red al obtener mis inscripciones');
    }
  }

  @override
  Future<void> unregisterFromEvent(int eventId) async {
    final apiUrl = _getApiUrl();
    final url = Uri.parse('$apiUrl/event-registrations/$eventId/unregister');
    try {
      final headers = await _getHeaders();
      final response = await client.delete(url, headers: headers);
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['success'] != true) {
          throw ServerException(jsonResponse['message'] ?? 'Error al cancelar registro');
        }
      } else {
        final errorDecode = json.decode(response.body);
        throw ServerException(errorDecode['message'] ?? 'Error al cancelar registro');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Error de conexión al cancelar registro');
    }
  }
}