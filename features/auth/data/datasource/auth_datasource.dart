import 'dart:convert';
import 'package:bienestar_integral_app/core/error/exception.dart';
import 'package:bienestar_integral_app/core/network/http_client.dart'; // <-- IMPORTANTE
import 'package:bienestar_integral_app/features/auth/data/models/auth_response_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

abstract class AuthDatasource {
  Future<AuthResponseModel> login(String email, String password);
}

class AuthDatasourceImpl implements AuthDatasource {
  final http.Client client;
  final String? _apiUrl = dotenv.env['API_URL'];

  // --- CAMBIO AQUÍ ---
  // El constructor ahora obtiene el cliente del Singleton si no se le pasa uno.
  // Esto es útil para las pruebas, donde puedes inyectar un cliente mock.
  AuthDatasourceImpl({http.Client? client})
      : this.client = client ?? HttpClient().client;

  @override
  Future<AuthResponseModel> login(String email, String password) async {
    if (_apiUrl == null) {
      throw ServerException('API_URL no encontrada en .env');
    }

    final url = Uri.parse('$_apiUrl/auth/login'); // Corregido para usar /login
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
        final Map<String, dynamic> errorResponse = json.decode(response.body);
        final errorMessage = errorResponse['message'] ?? 'Error desconocido';
        throw ServerException(errorMessage);
      }
    } catch (e) {
      throw NetworkException('No se pudo conectar al servidor.');
    }
  }
}