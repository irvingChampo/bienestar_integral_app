import 'package:bienestar_integral_app/core/error/exception.dart';
import 'package:bienestar_integral_app/features/home/data/datasource/kitchen_datasource.dart';
import 'package:bienestar_integral_app/features/home/data/repository/kitchen_repository_impl.dart';
import 'package:bienestar_integral_app/features/home/domain/entities/kitchen_subscription.dart';
import 'package:bienestar_integral_app/features/home/domain/usecase/get_my_kitchen_subscriptions.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

enum MyEventsStatus { initial, loading, success, error }

class MyEventsProvider extends ChangeNotifier {
  late final GetMyKitchenSubscriptions _getMyKitchenSubscriptions;

  MyEventsStatus _status = MyEventsStatus.initial;
  String? _errorMessage;
  List<KitchenSubscription> _subscriptions = [];

  MyEventsProvider() {
    // Reutilizamos la lógica de datos de 'home'
    final datasource = KitchenDatasourceImpl(client: http.Client());
    final repository = KitchenRepositoryImpl(datasource: datasource);
    _getMyKitchenSubscriptions = GetMyKitchenSubscriptions(repository);
  }

  MyEventsStatus get status => _status;
  String? get errorMessage => _errorMessage;
  List<KitchenSubscription> get subscriptions => _subscriptions;

  Future<void> fetchMySubscriptions() async {
    _status = MyEventsStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _subscriptions = await _getMyKitchenSubscriptions();
      _status = MyEventsStatus.success;
    } on ServerException catch (e) {
      _errorMessage = e.message;
      _status = MyEventsStatus.error;
    } on NetworkException catch (e) {
      _errorMessage = e.message;
      _status = MyEventsStatus.error;
    } catch (e) {
      _errorMessage = 'Ocurrió un error inesperado al cargar tus suscripciones.';
      _status = MyEventsStatus.error;
    }
    notifyListeners();
  }
}