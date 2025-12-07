import 'package:bienestar_integral_app/core/error/exception.dart';
import 'package:bienestar_integral_app/features/events/data/datasource/event_datasource.dart';
import 'package:bienestar_integral_app/features/events/data/repository/event_repository_impl.dart';
import 'package:bienestar_integral_app/features/events/domain/entities/event.dart';
import 'package:bienestar_integral_app/features/events/domain/entities/event_participant.dart';
import 'package:bienestar_integral_app/features/events/domain/usecase/create_event.dart';
import 'package:bienestar_integral_app/features/events/domain/usecase/delete_event.dart';
import 'package:bienestar_integral_app/features/events/domain/usecase/get_event_participants.dart';
import 'package:bienestar_integral_app/features/events/domain/usecase/get_events_by_kitchen.dart';
import 'package:bienestar_integral_app/features/events/domain/usecase/update_event.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

enum AdminEventStatus { initial, loading, success, error }

class AdminEventsProvider extends ChangeNotifier {
  late final CreateEvent _createEvent;
  late final UpdateEvent _updateEvent;
  late final DeleteEvent _deleteEvent;
  late final GetEventsByKitchen _getEventsByKitchen;
  late final GetEventParticipants _getEventParticipants;

  AdminEventStatus _status = AdminEventStatus.initial;
  String? _errorMessage;

  List<Event> _events = [];
  List<EventParticipant> _participants = [];

  AdminEventsProvider() {
    final datasource = EventDatasourceImpl(client: http.Client());
    final repository = EventRepositoryImpl(datasource: datasource);

    _createEvent = CreateEvent(repository);
    _updateEvent = UpdateEvent(repository);
    _deleteEvent = DeleteEvent(repository);
    _getEventsByKitchen = GetEventsByKitchen(repository);
    _getEventParticipants = GetEventParticipants(repository);
  }

  AdminEventStatus get status => _status;
  String? get errorMessage => _errorMessage;
  List<Event> get events => _events;
  List<EventParticipant> get participants => _participants;

  Future<void> loadKitchenEvents(int kitchenId) async {
    _status = AdminEventStatus.loading;
    notifyListeners();
    try {
      _events = await _getEventsByKitchen(kitchenId);
      _status = AdminEventStatus.success;
    } on ServerException catch (e) {
      _errorMessage = e.message;
      _status = AdminEventStatus.error;
    } catch (e) {
      _errorMessage = 'Error al cargar eventos: $e';
      _status = AdminEventStatus.error;
    }
    notifyListeners();
  }

  Future<void> loadEventParticipants(int eventId) async {
    _status = AdminEventStatus.loading;
    _participants = [];
    notifyListeners();
    try {
      _participants = await _getEventParticipants(eventId);
      _status = AdminEventStatus.success;
    } on ServerException catch (e) {
      _errorMessage = e.message;
      _status = AdminEventStatus.error;
    } catch (e) {
      _errorMessage = 'Error al cargar participantes: $e';
      _status = AdminEventStatus.error;
    }
    notifyListeners();
  }

  Future<bool> launchEvent({
    required int kitchenId,
    required String name,
    required String description,
    required String eventDate,
    required String startTime,
    required String endTime,
    required int maxCapacity,
    required int expectedDiners,
    required String eventType,
    String weatherCondition = 'Soleado',
  }) async {
    _status = AdminEventStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final eventData = {
        "kitchenId": kitchenId,
        "name": name,
        "description": description,
        "eventType": eventType,
        "eventDate": eventDate,
        "startTime": startTime,
        "endTime": endTime,
        "maxCapacity": maxCapacity,
        "expectedDiners": expectedDiners,
        "weatherCondition": weatherCondition,
      };

      await _createEvent(eventData);
      await loadKitchenEvents(kitchenId);
      _status = AdminEventStatus.success;
      notifyListeners();
      return true;
    } on ServerException catch (e) {
      _errorMessage = e.message;
      _status = AdminEventStatus.error;
    } catch (e) {
      _errorMessage = 'Error inesperado: $e';
      _status = AdminEventStatus.error;
    }
    notifyListeners();
    return false;
  }

  Future<bool> removeEvent(int eventId, int kitchenId) async {
    try {
      await _deleteEvent(eventId);
      _events.removeWhere((e) => e.id == eventId);
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  // --- NUEVO MÉTODO: EDITAR EVENTO ---
  Future<bool> editEvent({
    required int eventId,
    required int kitchenId,
    required String name,
    required String description,
    required String eventDate,
    required String startTime,
    required String endTime,
    required int maxCapacity,
    required int expectedDiners,
    required String eventType,
  }) async {
    _status = AdminEventStatus.loading;
    notifyListeners();

    try {
      final eventData = {
        "name": name,
        "description": description,
        "eventType": eventType,
        "eventDate": eventDate,
        "startTime": startTime,
        "endTime": endTime,
        "maxCapacity": maxCapacity,
        "expectedDiners": expectedDiners,
      };

      await _updateEvent(eventId, eventData);

      // Recargamos la lista para ver los cambios reflejados
      await loadKitchenEvents(kitchenId);

      _status = AdminEventStatus.success;
      notifyListeners();
      return true;
    } on ServerException catch (e) {
      _errorMessage = e.message;
      _status = AdminEventStatus.error;
    } catch (e) {
      _errorMessage = 'Error al editar evento: $e';
      _status = AdminEventStatus.error;
    }
    notifyListeners();
    return false;
  }
}