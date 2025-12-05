import 'package:bienestar_integral_app/core/error/exception.dart';
import 'package:bienestar_integral_app/features/events/data/datasource/event_datasource.dart';
import 'package:bienestar_integral_app/features/events/data/repository/event_repository_impl.dart';
import 'package:bienestar_integral_app/features/events/domain/entities/event_registration.dart';
import 'package:bienestar_integral_app/features/events/domain/usecase/get_my_event_registrations.dart';
import 'package:bienestar_integral_app/features/events/domain/usecase/unregister_from_event.dart';
import 'package:bienestar_integral_app/features/home/data/datasource/kitchen_datasource.dart';
import 'package:bienestar_integral_app/features/home/data/repository/kitchen_repository_impl.dart';
import 'package:bienestar_integral_app/features/home/domain/entities/kitchen_subscription.dart';
import 'package:bienestar_integral_app/features/home/domain/usecase/get_my_kitchen_subscriptions.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

enum MyEventsStatus { initial, loading, success, error }

class MyEventsProvider extends ChangeNotifier {
  // Casos de uso de Cocinas
  late final GetMyKitchenSubscriptions _getMyKitchenSubscriptions;

  // Casos de uso de Eventos (NUEVOS)
  late final GetMyEventRegistrations _getMyEventRegistrations;
  late final UnregisterFromEvent _unregisterFromEvent;

  MyEventsStatus _status = MyEventsStatus.initial;
  String? _errorMessage;

  // Listas de datos
  List<KitchenSubscription> _subscriptions = [];
  List<EventRegistration> _registrations = []; // <-- NUEVA LISTA

  // Estado de carga para acciones individuales (cancelar evento)
  int? _processingRegistrationId;

  MyEventsProvider() {
    final client = http.Client();

    // Configuración Home/Kitchens
    final kitchenDatasource = KitchenDatasourceImpl(client: client);
    final kitchenRepository = KitchenRepositoryImpl(datasource: kitchenDatasource);
    _getMyKitchenSubscriptions = GetMyKitchenSubscriptions(kitchenRepository);

    // Configuración Events (NUEVO)
    final eventDatasource = EventDatasourceImpl(client: client);
    final eventRepository = EventRepositoryImpl(datasource: eventDatasource);
    _getMyEventRegistrations = GetMyEventRegistrations(eventRepository);
    _unregisterFromEvent = UnregisterFromEvent(eventRepository);
  }

  MyEventsStatus get status => _status;
  String? get errorMessage => _errorMessage;
  List<KitchenSubscription> get subscriptions => _subscriptions;
  List<EventRegistration> get registrations => _registrations; // Getter
  int? get processingRegistrationId => _processingRegistrationId;

  // Cargar Cocinas (Pestaña 2)
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
      _errorMessage = 'Error al cargar suscripciones.';
      _status = MyEventsStatus.error;
    }
    notifyListeners();
  }

  // Cargar Eventos (Pestaña 1) - NUEVO
  Future<void> fetchMyRegistrations() async {
    _status = MyEventsStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _registrations = await _getMyEventRegistrations();
      _status = MyEventsStatus.success;
    } on ServerException catch (e) {
      _errorMessage = e.message;
      _status = MyEventsStatus.error;
    } on NetworkException catch (e) {
      _errorMessage = e.message;
      _status = MyEventsStatus.error;
    } catch (e) {
      _errorMessage = 'Error al cargar eventos.';
      _status = MyEventsStatus.error;
    }
    notifyListeners();
  }

  // Cancelar asistencia a un evento - NUEVO
  Future<bool> cancelEventRegistration(int eventId) async {
    _processingRegistrationId = eventId;
    notifyListeners();

    try {
      await _unregisterFromEvent(eventId);
      // Eliminamos localmente para actualizar la UI sin recargar todo
      _registrations.removeWhere((reg) => reg.eventId == eventId);
      return true;
    } on ServerException catch (e) {
      _errorMessage = e.message;
    } on NetworkException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = 'Error al cancelar asistencia.';
    } finally {
      _processingRegistrationId = null;
      notifyListeners();
    }
    return false;
  }
}