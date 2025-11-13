import 'dart:convert';
import 'package:bienestar_integral_app/core/error/exception.dart';
import 'package:bienestar_integral_app/core/network/http_client.dart';
import 'package:bienestar_integral_app/features/profile/data/models/user_profile_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

abstract class ProfileDatasource {
  Future<UserProfileModel> getProfile();
  Future<List<AvailabilitySlotModel>> getAvailability();
  Future<void> updateProfile(Map<String, dynamic> userData);
  Future<void> addUserSkill(int skillId);
  Future<void> removeUserSkill(int skillId);
  Future<void> createAvailabilitySlot(Map<String, dynamic> slotData);
  Future<void> updateAvailabilitySlot(String dayOfWeek, Map<String, dynamic> slotData);
  Future<void> removeAvailabilitySlot(String dayOfWeek);
}

class ProfileDatasourceImpl implements ProfileDatasource {
  final http.Client client;
  final String? _apiUrl = dotenv.env['API_URL'];

  ProfileDatasourceImpl({http.Client? client})
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
  Future<UserProfileModel> getProfile() async {
    final url = Uri.parse('$_apiUrl/users/profile');
    try {
      final headers = await _getHeaders();
      final response = await client.get(url, headers: headers);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return UserProfileModel.fromJson(jsonResponse['data']);
      } else {
        throw ServerException('Error al obtener el perfil (código ${response.statusCode})');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Error de red al obtener el perfil.');
    }
  }

  @override
  Future<List<AvailabilitySlotModel>> getAvailability() async {
    final url = Uri.parse('$_apiUrl/availability/me');
    try {
      final headers = await _getHeaders();
      final response = await client.get(url, headers: headers);
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> data = jsonResponse['data'];
        return data.map((json) => AvailabilitySlotModel.fromJson(json)).toList();
      } else {
        throw ServerException('Error al obtener la disponibilidad');
      }
    } catch (e) {
      throw NetworkException('Error de red al obtener la disponibilidad');
    }
  }

  @override
  Future<void> updateProfile(Map<String, dynamic> userData) async {
    final url = Uri.parse('$_apiUrl/users/profile');
    try {
      final headers = await _getHeaders();
      final response = await client.put(url, headers: headers, body: json.encode(userData));
      if (response.statusCode != 200) throw ServerException('Error al actualizar el perfil');
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Error de red al actualizar el perfil');
    }
  }

  @override
  Future<void> addUserSkill(int skillId) async {
    final url = Uri.parse('$_apiUrl/skills/me');
    try {
      final headers = await _getHeaders();
      final response = await client.post(url, headers: headers, body: json.encode({'skillId': skillId}));
      if (response.statusCode != 201) throw ServerException('Error al añadir la habilidad');
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Error de red al añadir la habilidad');
    }
  }

  @override
  Future<void> removeUserSkill(int skillId) async {
    final url = Uri.parse('$_apiUrl/skills/me/$skillId');
    try {
      final headers = await _getHeaders();
      final response = await client.delete(url, headers: headers);
      if (response.statusCode != 200) throw ServerException('Error al eliminar la habilidad');
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Error de red al eliminar la habilidad');
    }
  }

  @override
  Future<void> createAvailabilitySlot(Map<String, dynamic> slotData) async {
    final url = Uri.parse('$_apiUrl/availability/me');
    try {
      final headers = await _getHeaders();

      // --- CORRECCIÓN CLAVE ---
      // El endpoint POST espera un objeto que contenga la clave "availabilitySlots"
      // con un array de slots, incluso si es solo uno.
      final body = json.encode({
        'availabilitySlots': [slotData]
      });

      debugPrint("CREANDO disponibilidad con POST: $body");
      final response = await client.post(url, headers: headers, body: body);

      // La API de ejemplo para registro indica 201, pero es bueno ser flexible.
      if (response.statusCode != 201 && response.statusCode != 200) {
        debugPrint("Error al crear disponibilidad: ${response.body}");
        throw ServerException('Error al registrar la nueva disponibilidad');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Error de red al crear la disponibilidad');
    }
  }

  @override
  Future<void> updateAvailabilitySlot(String dayOfWeek, Map<String, dynamic> slotData) async {
    final url = Uri.parse('$_apiUrl/availability/me/${dayOfWeek.toUpperCase()}');
    try {
      final headers = await _getHeaders();
      final body = json.encode(slotData);
      debugPrint("ACTUALIZANDO disponibilidad para $dayOfWeek con PUT: $body");
      final response = await client.put(url, headers: headers, body: body);
      if (response.statusCode != 200) {
        debugPrint("Error al actualizar slot: ${response.body}");
        throw ServerException('Error al actualizar la disponibilidad para $dayOfWeek');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Error de red al actualizar la disponibilidad');
    }
  }

  @override
  Future<void> removeAvailabilitySlot(String dayOfWeek) async {
    final url = Uri.parse('$_apiUrl/availability/me/${dayOfWeek.toUpperCase()}');
    try {
      final headers = await _getHeaders();
      debugPrint("ELIMINANDO disponibilidad para $dayOfWeek con DELETE");
      final response = await client.delete(url, headers: headers);
      if (response.statusCode != 200) {
        debugPrint("Error al eliminar slot: ${response.body}");
        throw ServerException('Error al eliminar la disponibilidad para $dayOfWeek');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Error de red al eliminar la disponibilidad');
    }
  }
}