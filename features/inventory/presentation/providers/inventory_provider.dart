import 'package:bienestar_integral_app/core/error/exception.dart';
import 'package:bienestar_integral_app/features/inventory/data/datasource/inventory_datasource.dart';
import 'package:bienestar_integral_app/features/inventory/data/repository/inventory_repository_impl.dart';
import 'package:bienestar_integral_app/features/inventory/domain/entities/category.dart';
import 'package:bienestar_integral_app/features/inventory/domain/entities/inventory_item.dart';
import 'package:bienestar_integral_app/features/inventory/domain/entities/unit.dart'; // (+)
import 'package:bienestar_integral_app/features/inventory/domain/usecase/create_category.dart';
import 'package:bienestar_integral_app/features/inventory/domain/usecase/get_categories.dart';
import 'package:bienestar_integral_app/features/inventory/domain/usecase/get_kitchen_inventory.dart';
import 'package:bienestar_integral_app/features/inventory/domain/usecase/get_units.dart'; // (+)
import 'package:bienestar_integral_app/features/inventory/domain/usecase/manage_product_stock.dart';
import 'package:bienestar_integral_app/features/inventory/domain/usecase/product_management.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

enum InventoryStatus { initial, loading, success, error }

class InventoryProvider extends ChangeNotifier {
  late final GetKitchenInventory _getKitchenInventory;
  late final ProductManagement _productManagement;
  late final ManageProductStock _manageProductStock;

  late final GetCategories _getCategories;
  late final CreateCategory _createCategory;
  late final GetUnits _getUnits; // (+)

  InventoryStatus _status = InventoryStatus.initial;
  String? _errorMessage;
  List<InventoryItem> _fullInventory = [];
  int? _filterCategoryId;

  List<Category> _categories = [];
  List<Unit> _units = []; // (+) Lista de unidades

  InventoryProvider() {
    final datasource = InventoryDatasourceImpl(client: http.Client());
    final repository = InventoryRepositoryImpl(datasource: datasource);

    _getKitchenInventory = GetKitchenInventory(repository);
    _productManagement = ProductManagement(repository);
    _manageProductStock = ManageProductStock(repository);
    _getCategories = GetCategories(repository);
    _createCategory = CreateCategory(repository);
    _getUnits = GetUnits(repository); // (+)
  }

  InventoryStatus get status => _status;
  String? get errorMessage => _errorMessage;
  List<Category> get categories => _categories;
  List<Unit> get units => _units; // (+) Getter

  List<InventoryItem> get inventory {
    if (_filterCategoryId == null) {
      return _fullInventory;
    }
    return _fullInventory.where((item) => item.product.categoryId == _filterCategoryId).toList();
  }

  int? get currentFilter => _filterCategoryId;

  void setCategoryFilter(int? categoryId) {
    _filterCategoryId = categoryId;
    notifyListeners();
  }

  // (+) Cargar Unidades
  Future<void> loadUnits() async {
    try {
      _units = await _getUnits();
      notifyListeners();
    } catch (e) {
      debugPrint('Error cargando unidades: $e');
    }
  }

  Future<void> loadCategories() async {
    try {
      _categories = await _getCategories();
      notifyListeners();
    } catch (e) {
      debugPrint('Error cargando categorías: $e');
    }
  }

  Future<bool> createNewCategory(String name, String description) async {
    try {
      await _createCategory(name: name, description: description);
      await loadCategories();
      return true;
    } on ServerException catch (e) {
      _errorMessage = e.message;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'Error al crear la categoría.';
      notifyListeners();
      return false;
    }
  }

  Future<void> loadInventory(int kitchenId) async {
    _status = InventoryStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      // Cargamos TODO: inventario, categorías y unidades
      await Future.wait([
        _getKitchenInventory(kitchenId).then((value) => _fullInventory = value),
        loadCategories(),
        loadUnits() // (+)
      ]);
      _status = InventoryStatus.success;
    } on ServerException catch (e) {
      _errorMessage = e.message;
      _status = InventoryStatus.error;
    } catch (e) {
      _errorMessage = 'Error inesperado al cargar datos.';
      _status = InventoryStatus.error;
    }
    notifyListeners();
  }

  Future<bool> registerProduct({
    required int kitchenId,
    required String name,
    required String description,
    required int categoryId,
    required String unit,
    required bool perishable,
    int? shelfLifeDays,
  }) async {
    _status = InventoryStatus.loading;
    notifyListeners();

    try {
      await _productManagement.register(
        kitchenId: kitchenId,
        name: name,
        description: description,
        categoryId: categoryId,
        unit: unit,
        perishable: perishable,
        shelfLifeDays: shelfLifeDays,
      );
      await loadInventory(kitchenId);
      _status = InventoryStatus.success;
      return true;
    } on ServerException catch (e) {
      _errorMessage = e.message;
      _status = InventoryStatus.error;
    } catch (e) {
      _errorMessage = 'Error al registrar producto: $e';
      _status = InventoryStatus.error;
    }
    notifyListeners();
    return false;
  }

  // ... (Resto de métodos updateStock, setStock, etc. se mantienen IGUAL) ...
  Future<bool> editProduct({required int kitchenId, required int productId, required String name, required String description, required String unit}) async {
    try {
      await _productManagement.repository.updateProduct(kitchenId: kitchenId, productId: productId, name: name, description: description, unit: unit);
      await loadInventory(kitchenId);
      return true;
    } catch (e) {
      _errorMessage = 'Error al editar producto.';
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateStock({required int kitchenId, required int productId, required double amount, required bool isAdding}) async {
    try {
      if (isAdding) {
        await _manageProductStock.add(kitchenId, productId, amount);
      } else {
        await _manageProductStock.remove(kitchenId, productId, amount);
      }
      await loadInventory(kitchenId);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> setStock({required int kitchenId, required int productId, required double quantity}) async {
    try {
      await _manageProductStock.set(kitchenId, productId, quantity);
      await loadInventory(kitchenId);
      return true;
    } catch (e) {
      _errorMessage = 'Error al fijar el stock.';
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteProduct(int kitchenId, int productId) async {
    try {
      await _productManagement.delete(kitchenId, productId);
      _fullInventory.removeWhere((item) => item.product.id == productId);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'No se pudo eliminar el producto.';
      notifyListeners();
      return false;
    }
  }
}