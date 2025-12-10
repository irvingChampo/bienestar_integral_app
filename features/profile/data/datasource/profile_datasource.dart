import 'dart:convert';
import 'package:bienestar_integral_app/core/error/exception.dart';
import 'package:bienestar_integral_app/core/network/http_client.dart';
import 'package:bienestar_integral_app/features/profile/data/models/user_profile_model.dart';
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

  // Métodos de Verificación
  Future<void> resendEmailVerification();
  Future<void> resendPhoneVerification();
  Future<void> verifyPhone(String code);

  // (+) Método Eliminar Cuenta
  Future<void> deleteAccount();
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
      final body = json.encode({
        'availabilitySlots': [slotData]
      });
      final response = await client.post(url, headers: headers, body: body);
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ServerException('Error al registrar la nueva disponibilidad');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Error de red al crear la disponibilidad');
    }
  }

  @override
  Future<void> updateAvailabilitySlot(String dayOfWeek, Map<String, dynamic> slotData) async {
    final url = Uri.parse('$_apiUrl/availability/me/${dayOfWeek.toLowerCase()}');
    try {
      final headers = await _getHeaders();
      final body = json.encode(slotData);
      final response = await client.put(url, headers: headers, body: body);
      if (response.statusCode != 200) {
        throw ServerException('Error al actualizar la disponibilidad para $dayOfWeek');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Error de red al actualizar la disponibilidad');
    }
  }

  @override
  Future<void> removeAvailabilitySlot(String dayOfWeek) async {
    final url = Uri.parse('$_apiUrl/availability/me/${dayOfWeek.toLowerCase()}');
    try {
      final headers = await _getHeaders();
      final response = await client.delete(url, headers: headers);
      if (response.statusCode != 200) {
        throw ServerException('Error al eliminar la disponibilidad para $dayOfWeek');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Error de red al eliminar la disponibilidad');
    }
  }

  @override
  Future<void> resendEmailVerification() async {
    final url = Uri.parse('$_apiUrl/verification/email/resend');
    try {
      final headers = await _getHeaders();
      final response = await client.post(url, headers: headers);

      if (response.statusCode != 200 && response.statusCode != 201) {
        final Map<String, dynamic> errorResponse = json.decode(response.body);
        throw ServerException(errorResponse['message'] ?? 'Error al reenviar correo de verificación.');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Error de red al reenviar verificación de correo.');
    }
  }

  @override
  Future<void> resendPhoneVerification() async {
    final url = Uri.parse('$_apiUrl/verification/phone/resend');
    try {
      final headers = await _getHeaders();
      final response = await client.post(url, headers: headers);

      if (response.statusCode != 200 && response.statusCode != 201) {
        final Map<String, dynamic> errorResponse = json.decode(response.body);
        throw ServerException(errorResponse['message'] ?? 'Error al reenviar código SMS.');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Error de red al reenviar SMS.');
    }
  }

  @override
  Future<void> verifyPhone(String code) async {
    final url = Uri.parse('$_apiUrl/verification/phone');
    try {
      final headers = await _getHeaders();
      final body = json.encode({'code': code});

      final response = await client.post(url, headers: headers, body: body);

      if (response.statusCode != 200 && response.statusCode != 201) {
        final Map<String, dynamic> errorResponse = json.decode(response.body);
        throw ServerException(errorResponse['message'] ?? 'Código de verificación incorrecto.');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Error de red al verificar el teléfono.');
    }
  }

  // (+) Implementación de Eliminar Cuenta
  @override
  Future<void> deleteAccount() async {
    final url = Uri.parse('$_apiUrl/users/me');
    try {
      final headers = await _getHeaders();
      final response = await client.delete(url, headers: headers);

      if (response.statusCode == 200) {
        // Éxito
        return;
      } else {
        final Map<String, dynamic> errorResponse = json.decode(response.body);
        throw ServerException(errorResponse['message'] ?? 'Error al eliminar la cuenta.');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Error de conexión al intentar eliminar la cuenta.');
    }
  }
}