import 'dart:convert';
import 'package:bienestar_integral_app/core/error/exception.dart';
import 'package:bienestar_integral_app/core/network/http_client.dart';
import 'package:bienestar_integral_app/features/inventory/data/models/category_model.dart';
import 'package:bienestar_integral_app/features/inventory/data/models/inventory_item_model.dart';
import 'package:bienestar_integral_app/features/inventory/data/models/product_model.dart';
import 'package:bienestar_integral_app/features/inventory/data/models/unit_model.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

abstract class InventoryDatasource {
  Future<List<InventoryItemModel>> getKitchenInventory(int kitchenId);
  Future<ProductModel> getProductById(int kitchenId, int productId);
  Future<List<ProductModel>> getProductsByCategory(int kitchenId, int categoryId);

  Future<List<CategoryModel>> getCategories();
  Future<List<UnitModel>> getUnits();
  Future<void> createCategory(String name, String description);

  // Retorna el ID del producto creado
  Future<int> registerProduct(int kitchenId, Map<String, dynamic> data);

  Future<void> updateProduct(int kitchenId, int productId, Map<String, dynamic> data);
  Future<void> deleteProduct(int kitchenId, int productId);

  Future<void> addStock(int kitchenId, int productId, double amount);
  Future<void> removeStock(int kitchenId, int productId, double amount);
  Future<void> setStock(int kitchenId, int productId, double quantity);
}

class InventoryDatasourceImpl implements InventoryDatasource {
  final http.Client client;
  final String _baseUrl = "https://api-gateway.bim2.xyz/api/v1/inventory";

  InventoryDatasourceImpl({http.Client? client})
      : client = client ?? HttpClient().client;

  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');
    if (token == null) {
      throw ServerException('Sesión caducada. Inicia sesión de nuevo.');
    }
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  @override
  Future<int> registerProduct(int kitchenId, Map<String, dynamic> data) async {
    final url = Uri.parse('$_baseUrl/kitchens/$kitchenId/products/register');

    // Debug: Ver qué enviamos
    debugPrint('\n🔵 [REGISTER REQUEST] URL: $url');
    debugPrint('🔵 [REGISTER REQUEST] BODY: ${json.encode(data)}');

    try {
      final response = await client.post(
        url,
        headers: await _getHeaders(),
        body: json.encode(data),
      );

      debugPrint('🟠 [REGISTER RESPONSE] Status: ${response.statusCode}');
      debugPrint('🟠 [REGISTER RESPONSE] Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = json.decode(response.body);

        // --- LÓGICA DE EXTRACCIÓN DE ID ROBUSTA ---
        // Buscamos el ID en "product" -> "id" (Según tu JSON)
        // También probamos "data" -> "id" por si acaso cambia la estructura
        int? newId;

        if (jsonResponse['product'] != null && jsonResponse['product']['id'] != null) {
          newId = int.tryParse(jsonResponse['product']['id'].toString());
        } else if (jsonResponse['data'] != null && jsonResponse['data']['id'] != null) {
          newId = int.tryParse(jsonResponse['data']['id'].toString());
        }

        if (newId != null && newId > 0) {
          debugPrint('✅ ID EXTRAÍDO EXITOSAMENTE: $newId');
          return newId;
        }

        throw ServerException('Producto creado, pero no se pudo obtener el ID de la respuesta.');
      } else {
        // Manejo de errores del servidor
        String errorMsg = 'Error al registrar producto';
        try {
          final error = json.decode(response.body);
          if (error['message'] != null) errorMsg = error['message'];
        } catch (_) {}
        throw ServerException(errorMsg);
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Error de conexión al registrar producto');
    }
  }

  @override
  Future<void> addStock(int kitchenId, int productId, double amount) async {
    // Validación de seguridad antes de enviar
    if (productId <= 0) {
      throw ServerException('Error interno: ID de producto inválido ($productId) para agregar stock.');
    }

    final url = Uri.parse('$_baseUrl/kitchens/$kitchenId/items/$productId/add');

    debugPrint('\n🔵 [ADD STOCK] URL: $url');

    try {
      final response = await client.post(
        url,
        headers: await _getHeaders(),
        body: json.encode({'amount': amount}),
      );

      if (response.statusCode != 200) {
        debugPrint('🟠 [ADD STOCK ERROR]: ${response.body}');
        throw ServerException('Error al agregar stock');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Error de conexión al agregar stock');
    }
  }

  // --- RESTO DE MÉTODOS (Standard implementation) ---

  @override
  Future<List<UnitModel>> getUnits() async {
    final url = Uri.parse('$_baseUrl/units');
    try {
      final response = await client.get(url, headers: await _getHeaders());
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['success'] == true) {
          final List<dynamic> list = jsonResponse['units'];
          return list.map((e) => UnitModel.fromJson(e)).toList();
        }
      }
      throw ServerException('Error al obtener unidades');
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Error de conexión');
    }
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    final url = Uri.parse('$_baseUrl/categories');
    try {
      final response = await client.get(url, headers: await _getHeaders());
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['success'] == true) {
          final List<dynamic> list = jsonResponse['data'];
          return list.map((e) => CategoryModel.fromJson(e)).toList();
        }
      }
      throw ServerException('Error al obtener categorías');
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Error de conexión');
    }
  }

  @override
  Future<void> createCategory(String name, String description) async {
    final url = Uri.parse('$_baseUrl/categories');
    try {
      final response = await client.post(
        url,
        headers: await _getHeaders(),
        body: json.encode({'name': name, 'description': description}),
      );
      if (response.statusCode != 200 && response.statusCode != 201) throw ServerException('Error al crear categoría');
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Error de conexión');
    }
  }

  @override
  Future<List<InventoryItemModel>> getKitchenInventory(int kitchenId) async {
    final url = Uri.parse('$_baseUrl/kitchens/$kitchenId/items');
    try {
      final response = await client.get(url, headers: await _getHeaders());
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['success'] == true) {
          final List<dynamic> list = jsonResponse['items'];
          return list.map((e) => InventoryItemModel.fromJson(e)).toList();
        }
      }
      throw ServerException('Error al obtener inventario');
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Error de conexión');
    }
  }

  @override
  Future<void> removeStock(int kitchenId, int productId, double amount) async {
    final url = Uri.parse('$_baseUrl/kitchens/$kitchenId/items/$productId/remove');
    try {
      final response = await client.post(
        url,
        headers: await _getHeaders(),
        body: json.encode({'amount': amount}),
      );
      if (response.statusCode != 200) throw ServerException('Error al remover stock');
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Error de conexión');
    }
  }

  @override
  Future<void> setStock(int kitchenId, int productId, double quantity) async {
    final url = Uri.parse('$_baseUrl/kitchens/$kitchenId/items/$productId/set');
    try {
      final response = await client.post(
        url,
        headers: await _getHeaders(),
        body: json.encode({'quantity': quantity}),
      );
      if (response.statusCode != 200) throw ServerException('Error al establecer stock');
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Error de conexión');
    }
  }

  @override
  Future<void> deleteProduct(int kitchenId, int productId) async {
    final url = Uri.parse('$_baseUrl/kitchens/$kitchenId/products/$productId');
    try {
      final response = await client.delete(url, headers: await _getHeaders());
      if (response.statusCode != 200) throw ServerException('Error al eliminar producto');
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Error de conexión');
    }
  }

  @override
  Future<ProductModel> getProductById(int kitchenId, int productId) async {
    final url = Uri.parse('$_baseUrl/kitchens/$kitchenId/products/$productId');
    try {
      final response = await client.get(url, headers: await _getHeaders());
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return ProductModel.fromJson(jsonResponse['data']);
      }
      throw ServerException('Error al obtener producto');
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Error de conexión');
    }
  }

  @override
  Future<List<ProductModel>> getProductsByCategory(int kitchenId, int categoryId) async {
    final url = Uri.parse('$_baseUrl/kitchens/$kitchenId/products/category/$categoryId');
    try {
      final response = await client.get(url, headers: await _getHeaders());
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final List<dynamic> list = jsonResponse['data'];
        return list.map((e) => ProductModel.fromJson(e)).toList();
      }
      throw ServerException('Error al filtrar productos');
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Error de conexión');
    }
  }

  @override
  Future<void> updateProduct(int kitchenId, int productId, Map<String, dynamic> data) async {
    final url = Uri.parse('$_baseUrl/kitchens/$kitchenId/products/$productId');
    try {
      final response = await client.put(
        url,
        headers: await _getHeaders(),
        body: json.encode(data),
      );
      if (response.statusCode != 200) throw ServerException('Error al actualizar producto');
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Error de conexión');
    }
  }
}