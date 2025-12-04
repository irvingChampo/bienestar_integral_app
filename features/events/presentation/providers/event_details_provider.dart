// features/events/presentation/providers/event_details_provider.dart (NUEVO)

import 'package:bienestar_integral_app/core/error/exception.dart';
import 'package:bienestar_integral_app/features/home/data/datasource/kitchen_datasource.dart';
import 'package:bienestar_integral_app/features/home/data/repository/kitchen_repository_impl.dart';
import 'package:bienestar_integral_app/features/home/domain/entities/kitchen_detail.dart';
import 'package:bienestar_integral_app/features/home/domain/usecase/get_kitchen_details.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

enum EventDetailsStatus { initial, loading, success, error }

class EventDetailsProvider extends ChangeNotifier {
  late final GetKitchenDetails _getKitchenDetails;

  EventDetailsStatus _status = EventDetailsStatus.initial;
  String? _errorMessage;
  KitchenDetail? _kitchenDetail;

  EventDetailsProvider() {
    // Reutilizamos la lógica de datos y dominio de la feature 'home'
    final datasource = KitchenDatasourceImpl(client: http.Client());
    final repository = KitchenRepositoryImpl(datasource: datasource);
    _getKitchenDetails = GetKitchenDetails(repository);
  }

  EventDetailsStatus get status => _status;
  String? get errorMessage => _errorMessage;
  KitchenDetail? get kitchenDetail => _kitchenDetail;

  Future<void> fetchKitchenDetails(int kitchenId) async {
    _status = EventDetailsStatus.loading;
    _errorMessage = null;
    notifyListeners();
    try {
      _kitchenDetail = await _getKitchenDetails(kitchenId);
      _status = EventDetailsStatus.success;
    } on ServerException catch (e) {
      _errorMessage = 'Error del servidor: ${e.message}';
      _status = EventDetailsStatus.error;
    } on NetworkException catch (e) {
      _errorMessage = 'Error de red: ${e.message}';
      _status = EventDetailsStatus.error;
    } catch (e) {
      _errorMessage = 'Ocurrió un error inesperado al cargar los detalles.';
      _status = EventDetailsStatus.error;
    }
    notifyListeners();
  }
}