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
  Future<void> updateProfile(Map<String, dynamic> userData);
  Future<void> addUserSkill(int skillId);
  Future<void> removeUserSkill(int skillId);
  Future<void> updateAvailability(List<Map<String, String>> slots);
}

class ProfileDatasourceImpl implements ProfileDatasource {
  final http.Client client;
  final String? _apiUrl = dotenv.env['API_URL'];

  ProfileDatasourceImpl({http.Client? client})
      : client = client ?? HttpClient().client;

  // Helper para obtener las cabeceras con el token
  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');

    // Imprime en la consola el token que se está intentando usar.
    debugPrint("Token recuperado de SharedPreferences: $token");

    if (token == null) {
      // Si no hay token, la petición no puede continuar.
      throw ServerException('Token de autenticación no encontrado. Por favor, inicia sesión de nuevo.');
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
        // Imprime información útil si la petición falla
        debugPrint("Error al obtener perfil. Status: ${response.statusCode}, Body: ${response.body}");
        throw ServerException('Error al obtener el perfil (código ${response.statusCode})');
      }
    } catch (e) {
      if (e is ServerException) rethrow; // Mantiene el mensaje de error del servidor si ya lo capturamos
      debugPrint("Excepción de red/otro al obtener perfil: $e");
      throw NetworkException('Error de red al obtener el perfil.');
    }
  }

  @override
  Future<void> updateProfile(Map<String, dynamic> userData) async {
    final url = Uri.parse('$_apiUrl/users/profile');
    try {
      final headers = await _getHeaders();
      final response = await client.put(
        url,
        headers: headers,
        body: json.encode(userData),
      );

      if (response.statusCode != 200) {
        throw ServerException('Error al actualizar el perfil');
      }
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
      final response = await client.post(
        url,
        headers: headers,
        body: json.encode({'skillId': skillId}),
      );

      if (response.statusCode != 201) {
        throw ServerException('Error al añadir la habilidad');
      }
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

      if (response.statusCode != 200) {
        throw ServerException('Error al eliminar la habilidad');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Error de red al eliminar la habilidad');
    }
  }

  @override
  Future<void> updateAvailability(List<Map<String, String>> slots) async {
    final url = Uri.parse('$_apiUrl/availability/me');
    try {
      final headers = await _getHeaders();
      final response = await client.post(
        url,
        headers: headers,
        body: json.encode({'availabilitySlots': slots}),
      );

      if (response.statusCode != 201) {
        throw ServerException('Error al actualizar la disponibilidad');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Error de red al actualizar la disponibilidad');
    }
  }
}