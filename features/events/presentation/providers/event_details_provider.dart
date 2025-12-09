import 'package:bienestar_integral_app/core/error/exception.dart';
import 'package:bienestar_integral_app/features/home/data/datasource/kitchen_datasource.dart';
import 'package:bienestar_integral_app/features/home/data/repository/kitchen_repository_impl.dart';
import 'package:bienestar_integral_app/features/home/domain/entities/kitchen_detail.dart';
import 'package:bienestar_integral_app/features/home/domain/usecase/get_kitchen_details.dart';
import 'package:bienestar_integral_app/features/home/domain/usecase/get_my_subscriptions.dart';
import 'package:bienestar_integral_app/features/home/domain/usecase/subscribe_to_kitchen.dart';
import 'package:bienestar_integral_app/features/home/domain/usecase/unsubscribe_from_kitchen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

enum EventDetailsStatus { initial, loading, success, error }

class EventDetailsProvider extends ChangeNotifier {
  late final GetKitchenDetails _getKitchenDetails;
  late final SubscribeToKitchen _subscribeToKitchen;
  late final UnsubscribeFromKitchen _unsubscribeFromKitchen;
  late final GetMySubscriptions _getMySubscriptions;

  EventDetailsStatus _status = EventDetailsStatus.initial;
  String? _errorMessage;
  KitchenDetail? _kitchenDetail;

  bool _isSubscribing = false;
  bool _isSubscribed = false;

  EventDetailsProvider() {
    final datasource = KitchenDatasourceImpl(client: http.Client());
    final repository = KitchenRepositoryImpl(datasource: datasource);

    _getKitchenDetails = GetKitchenDetails(repository);
    _subscribeToKitchen = SubscribeToKitchen(repository);
    _unsubscribeFromKitchen = UnsubscribeFromKitchen(repository);
    _getMySubscriptions = GetMySubscriptions(repository);
  }

  EventDetailsStatus get status => _status;
  String? get errorMessage => _errorMessage;
  KitchenDetail? get kitchenDetail => _kitchenDetail;
  bool get isSubscribing => _isSubscribing;
  bool get isSubscribed => _isSubscribed;

  Future<void> fetchKitchenDetails(int kitchenId) async {
    _status = EventDetailsStatus.loading;
    _errorMessage = null;
    notifyListeners();
    try {
      final detailsFuture = _getKitchenDetails(kitchenId);
      final subscriptionsFuture = _getMySubscriptions();

      final results = await Future.wait([detailsFuture, subscriptionsFuture]);

      _kitchenDetail = results[0] as KitchenDetail;
      final subscribedIds = results[1] as List<int>;

      _isSubscribed = subscribedIds.contains(kitchenId);

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

  Future<bool> subscribe(int kitchenId) async {
    _isSubscribing = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _subscribeToKitchen(kitchenId);
      _isSubscribed = true;
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

  Future<bool> unsubscribe(int kitchenId) async {
    _isSubscribing = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _unsubscribeFromKitchen(kitchenId);
      _isSubscribed = false;
      return true;
    } on ServerException catch (e) {
      _errorMessage = e.message;
    } on NetworkException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = 'Ocurrió un error al intentar desuscribirse.';
    } finally {
      _isSubscribing = false;
      notifyListeners();
    }
    return false;
  }
}