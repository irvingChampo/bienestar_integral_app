// features/auth/data/datasource/auth_datasource.dart (ACTUALIZADO)

import 'dart:convert';
import 'package:bienestar_integral_app/core/error/exception.dart';
import 'package:bienestar_integral_app/core/network/http_client.dart';
import 'package:bienestar_integral_app/features/auth/data/models/auth_response_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

abstract class AuthDatasource {
  Future<AuthResponseModel> login(String email, String password);
  Future<Map<String, dynamic>> googleLogin(String token);
}

class AuthDatasourceImpl implements AuthDatasource {
  final http.Client client;
  final String? _apiUrl = dotenv.env['API_URL'];

  AuthDatasourceImpl({http.Client? client})
      : client = client ?? HttpClient().client;

  @override
  Future<AuthResponseModel> login(String email, String password) async {
    if (_apiUrl == null) {
      throw ServerException('API_URL no encontrada en .env');
    }

    final url = Uri.parse('$_apiUrl/auth/login');
    try {
      final response = await client.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return AuthResponseModel.fromJson(jsonResponse['data']);
      } else {
        // --- LÓGICA DE MANEJO DE ERRORES MEJORADA ---
        if (response.statusCode == 401) {
          // Si el error es 401, es un problema de credenciales.
          throw InvalidCredentialsException('Correo o contraseña incorrectos.');
        } else {
          // Para cualquier otro error del servidor (500, 404, etc.), usamos la excepción genérica.
          final Map<String, dynamic> errorResponse = json.decode(response.body);
          final errorMessage = errorResponse['message'] ?? 'Error desconocido del servidor';
          throw ServerException(errorMessage);
        }
        // --- FIN DE LA MEJORA ---
      }
    } on InvalidCredentialsException {
      rethrow; // Re-lanzamos la excepción específica para que el provider la atrape.
    } on ServerException {
      rethrow; // Re-lanzamos la excepción de servidor.
    } catch (e) {

      throw NetworkException('No se pudo conectar al servidor. Revisa tu conexión a internet.');
    }
  }
  @override
  Future<Map<String, dynamic>> googleLogin(String googleToken) async {
    if (_apiUrl == null) {
      throw ServerException('API_URL no encontrada en .env');
    }

    final url = Uri.parse('$_apiUrl/auth/google');

    try {
      final response = await client.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'token': googleToken}),
      );

      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      if (response.statusCode == 200) {
        return jsonResponse;
      } else {
        final errorMessage = jsonResponse['message'] ?? 'Error al iniciar con Google';
        throw ServerException(errorMessage);
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Error de conexión con el servidor.');
    }
  }
}
