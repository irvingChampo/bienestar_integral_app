import 'package:bienestar_integral_app/core/error/exception.dart';
import 'package:bienestar_integral_app/features/events/data/datasource/event_datasource.dart';
import 'package:bienestar_integral_app/features/events/data/repository/event_repository_impl.dart';
import 'package:bienestar_integral_app/features/events/domain/entities/event.dart';
import 'package:bienestar_integral_app/features/events/domain/usecase/get_events_by_kitchen.dart';
import 'package:bienestar_integral_app/features/events/domain/usecase/register_to_event.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

enum EventsStatus { initial, loading, success, error }

class EventsProvider extends ChangeNotifier {
  late final GetEventsByKitchen _getEventsByKitchen;
  late final RegisterToEvent _registerToEvent;

  EventsStatus _status = EventsStatus.initial;
  String? _errorMessage;
  List<Event> _events = [];

  // Para saber qué evento se está procesando actualmente (para el spinner en el botón específico)
  int? _processingEventId;

  EventsProvider() {
    final datasource = EventDatasourceImpl(client: http.Client());
    final repository = EventRepositoryImpl(datasource: datasource);
    _getEventsByKitchen = GetEventsByKitchen(repository);
    _registerToEvent = RegisterToEvent(repository);
  }

  EventsStatus get status => _status;
  String? get errorMessage => _errorMessage;
  List<Event> get events => _events;
  int? get processingEventId => _processingEventId;

  Future<void> fetchEventsByKitchen(int kitchenId) async {
    _status = EventsStatus.loading;
    _errorMessage = null;
    _events = [];
    notifyListeners();

    try {
      _events = await _getEventsByKitchen(kitchenId);
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

  Future<bool> joinEvent(int eventId) async {
    _processingEventId = eventId;
    _errorMessage = null;
    notifyListeners();

    try {
      await _registerToEvent(eventId);
      return true;
    } on ServerException catch (e) {
      _errorMessage = e.message;
    } on NetworkException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = 'Error al inscribirse al evento.';
    } finally {
      _processingEventId = null;
      notifyListeners();
    }
    return false;
  }
}