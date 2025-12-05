import 'dart:convert';
import 'package:bienestar_integral_app/core/error/exception.dart';
import 'package:bienestar_integral_app/core/network/http_client.dart';
import 'package:bienestar_integral_app/features/events/data/models/event_model.dart';
import 'package:bienestar_integral_app/features/events/data/models/event_participant_model.dart';
import 'package:bienestar_integral_app/features/events/data/models/event_registration_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

abstract class EventDatasource {
  Future<List<EventModel>> getEventsByKitchen(int kitchenId);
  Future<void> registerToEvent(int eventId);
  Future<List<EventRegistrationModel>> getMyRegistrations();
  Future<void> unregisterFromEvent(int eventId);

  // Admin Methods
  Future<void> createEvent(Map<String, dynamic> eventData);
  Future<void> updateEvent(int eventId, Map<String, dynamic> eventData);
  Future<void> deleteEvent(int eventId);
  Future<List<EventParticipantModel>> getEventParticipants(int eventId);
  Future<List<EventParticipantModel>> getKitchenSubscribers(int kitchenId);
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
    };
  }

  String _getApiUrl() {
    var apiUrl = dotenv.env['API_URL'];
    if (apiUrl == null || apiUrl.isEmpty) {
      throw ServerException('API_URL no configurada.');
    }
    if (apiUrl.endsWith('/')) {
      apiUrl = apiUrl.substring(0, apiUrl.length - 1);
    }
    return apiUrl;
  }

  // --- MÉTODOS DE USUARIO / VOLUNTARIO ---

  @override
  Future<List<EventModel>> getEventsByKitchen(int kitchenId) async {
    final apiUrl = _getApiUrl();
    final url = Uri.parse('$apiUrl/events/kitchen/$kitchenId');
    try {
      final response = await client.get(url, headers: await _getHeaders());
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final List<dynamic> data = jsonResponse['data'];
        return data.map((json) => EventModel.fromJson(json)).toList();
      } else {
        throw ServerException('Error al cargar eventos');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Error de red');
    }
  }

  @override
  Future<void> registerToEvent(int eventId) async {
    final apiUrl = _getApiUrl();
    final url = Uri.parse('$apiUrl/event-registrations/$eventId/register');
    try {
      final response = await client.post(url, headers: await _getHeaders());
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ServerException('Error al inscribirse');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Error de conexión');
    }
  }

  @override
  Future<List<EventRegistrationModel>> getMyRegistrations() async {
    final apiUrl = _getApiUrl();
    final url = Uri.parse('$apiUrl/event-registrations/my-registrations');
    try {
      final response = await client.get(url, headers: await _getHeaders());
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> data = jsonResponse['data'];
        return data.map((json) => EventRegistrationModel.fromJson(json)).toList();
      } else {
        throw ServerException('Error al obtener mis inscripciones');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Error de red');
    }
  }

  @override
  Future<void> unregisterFromEvent(int eventId) async {
    final apiUrl = _getApiUrl();
    final url = Uri.parse('$apiUrl/event-registrations/$eventId/unregister');
    try {
      final response = await client.delete(url, headers: await _getHeaders());
      if (response.statusCode != 200) {
        throw ServerException('Error al cancelar registro');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Error de conexión');
    }
  }

  // --- MÉTODOS DE ADMIN ---

  @override
  Future<void> createEvent(Map<String, dynamic> eventData) async {
    final apiUrl = _getApiUrl();
    final url = Uri.parse('$apiUrl/events');
    debugPrint('🔵 [POST] Creando evento: $url');
    debugPrint('📦 DATA: $eventData');

    try {
      final response = await client.post(
        url,
        headers: await _getHeaders(),
        body: json.encode(eventData),
      );

      debugPrint('📡 STATUS: ${response.statusCode}');
      debugPrint('📩 BODY: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['success'] != true) {
          throw ServerException(jsonResponse['message'] ?? 'Error al crear evento');
        }
      } else {
        final error = json.decode(response.body);
        throw ServerException(error['message'] ?? 'Error al crear evento');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Error de conexión al crear evento');
    }
  }

  @override
  Future<void> updateEvent(int eventId, Map<String, dynamic> eventData) async {
    final apiUrl = _getApiUrl();
    final url = Uri.parse('$apiUrl/events/$eventId');

    try {
      final response = await client.put(
        url,
        headers: await _getHeaders(),
        body: json.encode(eventData),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['success'] != true) {
          throw ServerException(jsonResponse['message'] ?? 'Error al actualizar');
        }
      } else {
        throw ServerException('Error al actualizar evento (${response.statusCode})');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Error de conexión al actualizar');
    }
  }

  @override
  Future<void> deleteEvent(int eventId) async {
    final apiUrl = _getApiUrl();
    final url = Uri.parse('$apiUrl/events/$eventId');

    try {
      final response = await client.delete(url, headers: await _getHeaders());
      if (response.statusCode == 200) {
        // Success
      } else {
        throw ServerException('Error al eliminar evento');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Error de conexión al eliminar');
    }
  }

  @override
  Future<List<EventParticipantModel>> getEventParticipants(int eventId) async {
    final apiUrl = _getApiUrl();
    final url = Uri.parse('$apiUrl/event-registrations/$eventId/participants');

    try {
      final response = await client.get(url, headers: await _getHeaders());
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final List<dynamic> data = jsonResponse['data'];
        return data.map((json) => EventParticipantModel.fromJson(json)).toList();
      } else {
        throw ServerException('Error al obtener participantes');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Error de red al cargar participantes');
    }
  }

  @override
  Future<List<EventParticipantModel>> getKitchenSubscribers(int kitchenId) async {
    final apiUrl = _getApiUrl();
    final url = Uri.parse('$apiUrl/event-subscriptions/$kitchenId');

    try {
      final response = await client.get(url, headers: await _getHeaders());
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final List<dynamic> data = jsonResponse['data'];
        return data.map((json) => EventParticipantModel.fromJson(json)).toList();
      } else {
        throw ServerException('Error al obtener suscriptores');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Error de red');
    }
  }
}