import 'dart:convert';
import 'package:bienestar_integral_app/core/error/exception.dart';
import 'package:bienestar_integral_app/core/network/http_client.dart';
import 'package:bienestar_integral_app/features/register/data/models/municipality_model.dart';
import 'package:bienestar_integral_app/features/register/data/models/skill_model.dart';
import 'package:bienestar_integral_app/features/register/data/models/state_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

abstract class RegisterDatasource {
  Future<List<StateModel>> getStates();
  Future<List<MunicipalityModel>> getMunicipalities(String stateId);
  Future<List<SkillModel>> getSkills();
  Future<void> registerUser(Map<String, dynamic> userData);
}

class RegisterDatasourceImpl implements RegisterDatasource {
  final http.Client client;
  final String? _apiUrl = dotenv.env['API_URL'];

  RegisterDatasourceImpl({http.Client? client})
      : client = client ?? HttpClient().client;

  @override
  Future<List<StateModel>> getStates() async {
    final url = Uri.parse('$_apiUrl/states');
    try {
      final response = await client.get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> data = jsonResponse['data'];
        return data.map((json) => StateModel.fromJson(json)).toList();
      } else {
        throw ServerException('Error al obtener los estados');
      }
    } catch (e) {
      throw NetworkException('Error de red al obtener los estados');
    }
  }

  @override
  Future<List<MunicipalityModel>> getMunicipalities(String stateId) async {
    final url = Uri.parse('$_apiUrl/states/$stateId/municipalities');
    try {
      final response = await client.get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> data = jsonResponse['data'];
        return data.map((json) => MunicipalityModel.fromJson(json)).toList();
      } else {
        throw ServerException('Error al obtener los municipios');
      }
    } catch (e) {
      throw NetworkException('Error de red al obtener los municipios');
    }
  }

  @override
  Future<List<SkillModel>> getSkills() async {
    // --- INICIO DE LA CORRECCIÓN ---
    // Se reemplaza la lista local por una llamada real a la API.
    final url = Uri.parse('$_apiUrl/skills');
    try {
      final response = await client.get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        // La respuesta de la API tiene los datos dentro de una clave "data".
        final List<dynamic> data = jsonResponse['data'];
        return data.map((json) => SkillModel.fromJson(json)).toList();
      } else {
        throw ServerException('Error al obtener las habilidades');
      }
    } catch (e) {
      throw NetworkException('Error de red al obtener las habilidades');
    }
    // --- FIN DE LA CORRECCIÓN ---
  }

  @override
  Future<void> registerUser(Map<String, dynamic> userData) async {
    final url = Uri.parse('$_apiUrl/auth/register');
    try {
      final body = json.encode(userData);
      debugPrint("--- ENVIANDO PETICIÓN DE REGISTRO ---");
      debugPrint(body);

      final response = await client.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode != 201) {
        final error = json.decode(response.body);
        throw ServerException(error['message'] ?? 'Error al registrar usuario');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Error de red al registrar usuario');
    }
  }
}