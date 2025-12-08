import 'package:bienestar_integral_app/core/error/exception.dart';
import 'package:bienestar_integral_app/features/events/data/datasource/event_datasource.dart';
import 'package:bienestar_integral_app/features/events/data/repository/event_repository_impl.dart';
import 'package:bienestar_integral_app/features/events/domain/entities/event.dart';
import 'package:bienestar_integral_app/features/events/domain/usecase/get_events_by_kitchen.dart';
import 'package:bienestar_integral_app/features/events/domain/usecase/get_my_event_registrations.dart'; // NUEVO
import 'package:bienestar_integral_app/features/events/domain/usecase/register_to_event.dart';
import 'package:bienestar_integral_app/features/events/domain/usecase/unregister_from_event.dart'; // NUEVO
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

enum EventsStatus { initial, loading, success, error }

class EventsProvider extends ChangeNotifier {
  late final GetEventsByKitchen _getEventsByKitchen;
  late final RegisterToEvent _registerToEvent;
  // Nuevos casos de uso para manejar el estado completo
  late final GetMyEventRegistrations _getMyEventRegistrations;
  late final UnregisterFromEvent _unregisterFromEvent;

  EventsStatus _status = EventsStatus.initial;
  String? _errorMessage;
  List<Event> _events = [];

  // Para saber qué evento se está procesando actualmente
  int? _processingEventId;

  // Lista local de IDs de eventos inscritos
  Set<int> _registeredEventIds = {};

  EventsProvider() {
    final datasource = EventDatasourceImpl(client: http.Client());
    final repository = EventRepositoryImpl(datasource: datasource);

    _getEventsByKitchen = GetEventsByKitchen(repository);
    _registerToEvent = RegisterToEvent(repository);
    _getMyEventRegistrations = GetMyEventRegistrations(repository);
    _unregisterFromEvent = UnregisterFromEvent(repository);
  }

  EventsStatus get status => _status;
  String? get errorMessage => _errorMessage;
  List<Event> get events => _events;
  int? get processingEventId => _processingEventId;

  bool isRegistered(int eventId) => _registeredEventIds.contains(eventId);

  Future<void> fetchEventsByKitchen(int kitchenId) async {
    _status = EventsStatus.loading;
    _errorMessage = null;
    _events = [];
    notifyListeners();

    try {
      // 1. Cargamos los eventos de la cocina
      // 2. Y TAMBIÉN cargamos mis registros actuales para saber en cuáles estoy
      final results = await Future.wait([
        _getEventsByKitchen(kitchenId),
        _getMyEventRegistrations(),
      ]);

      _events = results[0] as List<Event>;
      final myRegistrations = results[1] as List<dynamic>;

      // Actualizamos el Set con los IDs que vienen del servidor
      _registeredEventIds = myRegistrations.map((r) => r.eventId as int).toSet();

      _status = EventsStatus.success;
    } on ServerException catch (e) {
      _errorMessage = e.message;
      _status = EventsStatus.error;
    } on NetworkException catch (e) {
      _errorMessage = e.message;
      _status = EventsStatus.error;
    } catch (e) {
      _errorMessage = 'Error inesperado al cargar eventos.';
      _status = EventsStatus.error;
    }
    notifyListeners();
  }

  // Inscribirse
  Future<bool> joinEvent(int eventId) async {
    _processingEventId = eventId;
    _errorMessage = null;
    notifyListeners();

    try {
      await _registerToEvent(eventId);
      _registeredEventIds.add(eventId); // Agregamos al Set local
      return true;
    } on ServerException catch (e) {
      _errorMessage = e.message;
    } on NetworkException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = 'Error al inscribirse.';
    } finally {
      _processingEventId = null;
      notifyListeners();
    }
    return false;
  }

  // Cancelar (NUEVO MÉTODO)
  Future<bool> leaveEvent(int eventId) async {
    _processingEventId = eventId;
    _errorMessage = null;
    notifyListeners();

    try {
      await _unregisterFromEvent(eventId);
      _registeredEventIds.remove(eventId); // Eliminamos del Set local
      return true;
    } on ServerException catch (e) {
      _errorMessage = e.message;
    } on NetworkException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = 'Error al cancelar registro.';
    } finally {
      _processingEventId = null;
      notifyListeners();
    }
    return false;
  }
}