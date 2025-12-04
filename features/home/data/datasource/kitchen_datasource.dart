// features/home/data/datasource/kitchen_datasource.dart (MANEJO DE ERRORES MEJORADO)

import 'dart:convert';
import 'package:bienestar_integral_app/core/error/exception.dart';
import 'package:bienestar_integral_app/core/network/http_client.dart';
import 'package:bienestar_integral_app/features/home/data/models/kitchen_detail_model.dart';
import 'package:bienestar_integral_app/features/home/data/models/kitchen_model.dart';
import 'package:flutter/foundation.dart'; // Importar para debugPrint
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// ... (interfaz abstracta sin cambios)
abstract class KitchenDatasource {
  Future<List<KitchenModel>> getNearbyKitchens();
  Future<KitchenDetailModel> getKitchenDetails(int kitchenId);
}


class KitchenDatasourceImpl implements KitchenDatasource {
  // ... (constructor y _getHeaders sin cambios)
  final http.Client client;
  final String? _apiUrl = dotenv.env['API_URL'];

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

  @override
  Future<List<KitchenModel>> getNearbyKitchens() async {
    if (_apiUrl == null) throw ServerException('API_URL no encontrada en .env');
    final url = Uri.parse('$_apiUrl/kitchens/nearby');
    try {
      final headers = await _getHeaders();
      final response = await client.get(url, headers: headers);

      if (response.statusCode == 200) {
        // --- INICIO DE LA CORRECCIÓN DE MANEJO DE ERRORES ---
        try {
          final Map<String, dynamic> jsonResponse = json.decode(response.body);
          final List<dynamic> data = jsonResponse['data'];
          return data.map((json) => KitchenModel.fromJson(json)).toList();
        } catch (e) {
          // Si el JSON es inválido o tiene una estructura inesperada, lo capturamos aquí.
          debugPrint("Error de parseo de JSON en getNearbyKitchens: $e");
          throw ServerException("El servidor envió una respuesta con formato incorrecto.");
        }
        // --- FIN DE LA CORRECCIÓN ---
      } else {
        throw ServerException('Error al obtener las cocinas (código ${response.statusCode})');
      }
    } on ServerException {
      rethrow; // Re-lanzamos las excepciones que ya son del tipo correcto.
    } catch (e) {
      // Cualquier otro error (timeout, sin conexión, etc.) se considera de red.
      debugPrint("Error de red en getNearbyKitchens: $e");
      throw NetworkException('Error de red al obtener las cocinas.');
    }
  }

  // ... (getKitchenDetails sin cambios, pero aplicaría la misma lógica)
  @override
  Future<KitchenDetailModel> getKitchenDetails(int kitchenId) async {
    if (_apiUrl == null) throw ServerException('API_URL no encontrada en .env');
    final url = Uri.parse('$_apiUrl/kitchens/$kitchenId');
    try {
      final headers = await _getHeaders();
      final response = await client.get(url, headers: headers);

      if (response.statusCode == 200) {
        try {
          final Map<String, dynamic> jsonResponse = json.decode(response.body);
          debugPrint('>>> JSON RECIBIDO DEL SERVIDOR: ${json.encode(jsonResponse)}');
          return KitchenDetailModel.fromJson(jsonResponse['data']);
        } catch(e) {
          debugPrint("Error de parseo de JSON en getKitchenDetails: $e");
          throw ServerException("El servidor envió una respuesta con formato incorrecto.");
        }
      } else {
        throw ServerException('Error al obtener detalles de la cocina (código ${response.statusCode})');
      }
    } on ServerException {
      rethrow;
    } catch (e) {
      debugPrint("Error de red en getKitchenDetails: $e");
      throw NetworkException('Error de red al obtener detalles de la cocina.');
    }
  }
}