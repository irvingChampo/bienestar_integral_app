// features/home/presentation/providers/home_provider.dart (NUEVO)

import 'package:bienestar_integral_app/core/error/exception.dart';
import 'package:bienestar_integral_app/features/home/data/datasource/kitchen_datasource.dart';
import 'package:bienestar_integral_app/features/home/data/repository/kitchen_repository_impl.dart';
import 'package:bienestar_integral_app/features/home/domain/entities/kitchen.dart';
import 'package:bienestar_integral_app/features/home/domain/usecase/get_nearby_kitchens.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

enum HomeStatus { initial, loading, success, error }

class HomeProvider extends ChangeNotifier {
  late final GetNearbyKitchens _getNearbyKitchens;

  HomeStatus _status = HomeStatus.initial;
  String? _errorMessage;
  List<Kitchen> _kitchens = [];

  HomeProvider() {
    final datasource = KitchenDatasourceImpl(client: http.Client());
    final repository = KitchenRepositoryImpl(datasource: datasource);
    _getNearbyKitchens = GetNearbyKitchens(repository);
  }

  HomeStatus get status => _status;
  String? get errorMessage => _errorMessage;
  List<Kitchen> get kitchens => _kitchens;

  Future<void> fetchNearbyKitchens() async {
    _status = HomeStatus.loading;
    _errorMessage = null;
    notifyListeners();
    try {
      _kitchens = await _getNearbyKitchens();
      _status = HomeStatus.success;
    } on ServerException catch (e) {
      _errorMessage = 'Error del servidor: ${e.message}';
      _status = HomeStatus.error;
    } on NetworkException catch (e) {
      _errorMessage = 'Error de red: ${e.message}';
      _status = HomeStatus.error;
    } catch (e) {
      _errorMessage = 'Ocurrió un error inesperado al cargar las cocinas.';
      _status = HomeStatus.error;
    }
    notifyListeners();
  }
}