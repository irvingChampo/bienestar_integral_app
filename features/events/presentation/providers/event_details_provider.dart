import 'package:bienestar_integral_app/core/error/exception.dart';
import 'package:bienestar_integral_app/features/home/data/datasource/kitchen_datasource.dart';
import 'package:bienestar_integral_app/features/home/data/repository/kitchen_repository_impl.dart';
import 'package:bienestar_integral_app/features/home/domain/entities/kitchen_detail.dart';
import 'package:bienestar_integral_app/features/home/domain/usecase/get_kitchen_details.dart';
import 'package:bienestar_integral_app/features/home/domain/usecase/subscribe_to_kitchen.dart'; // <-- 1. NUEVO IMPORT
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

enum EventDetailsStatus { initial, loading, success, error }

class EventDetailsProvider extends ChangeNotifier {
  late final GetKitchenDetails _getKitchenDetails;
  late final SubscribeToKitchen _subscribeToKitchen; // <-- 2. NUEVO CASO DE USO

  EventDetailsStatus _status = EventDetailsStatus.initial;
  String? _errorMessage;
  KitchenDetail? _kitchenDetail;

  // --- 3. NUEVO ESTADO PARA LA ACCIÓN DE SUSCRIPCIÓN ---
  bool _isSubscribing = false;
  bool get isSubscribing => _isSubscribing;

  EventDetailsProvider() {
    // Reutilizamos la lógica de datos y dominio de la feature 'home'
    final datasource = KitchenDatasourceImpl(client: http.Client());
    final repository = KitchenRepositoryImpl(datasource: datasource);

    _getKitchenDetails = GetKitchenDetails(repository);
    _subscribeToKitchen = SubscribeToKitchen(repository); // <-- INICIALIZACIÓN
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

  // --- 4. NUEVO MÉTODO DE SUSCRIPCIÓN ---
  Future<bool> subscribe(int kitchenId) async {
    _isSubscribing = true;
    _errorMessage = null;
    notifyListeners(); // Notificamos para que el botón muestre el spinner

    try {
      await _subscribeToKitchen(kitchenId);
      // Opcional: Podrías volver a llamar a fetchKitchenDetails(kitchenId)
      // si quisieras actualizar la UI para decir "Ya estás inscrito".
      // Por ahora, solo retornamos true.
      return true;
    } on ServerException catch (e) {
      _errorMessage = e.message;
    } on NetworkException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = 'Ocurrió un error al intentar inscribirse.';
    } finally {
      _isSubscribing = false;
      notifyListeners();
    }
    return false;
  }
}