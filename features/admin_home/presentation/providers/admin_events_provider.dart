import 'package:bienestar_integral_app/core/error/exception.dart';
import 'package:bienestar_integral_app/features/events/data/datasource/event_datasource.dart';
import 'package:bienestar_integral_app/features/events/data/repository/event_repository_impl.dart';
import 'package:bienestar_integral_app/features/events/domain/entities/event.dart';
import 'package:bienestar_integral_app/features/events/domain/entities/event_participant.dart';
import 'package:bienestar_integral_app/features/events/domain/usecase/create_event.dart';
import 'package:bienestar_integral_app/features/events/domain/usecase/delete_event.dart';
import 'package:bienestar_integral_app/features/events/domain/usecase/get_event_participants.dart'; // Nuevo
import 'package:bienestar_integral_app/features/events/domain/usecase/get_events_by_kitchen.dart'; // Reutilizamos este
import 'package:bienestar_integral_app/features/events/domain/usecase/update_event.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

enum AdminEventStatus { initial, loading, success, error }

class AdminEventsProvider extends ChangeNotifier {
  late final CreateEvent _createEvent;
  late final UpdateEvent _updateEvent;
  late final DeleteEvent _deleteEvent;

  // Casos de uso de lectura (GET)
  late final GetEventsByKitchen _getEventsByKitchen;
  late final GetEventParticipants _getEventParticipants;

  AdminEventStatus _status = AdminEventStatus.initial;
  String? _errorMessage;

  // Listas de datos
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

  // --- GET: Obtener eventos de la cocina ---
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

  // --- GET: Obtener participantes de un evento ---
  Future<void> loadEventParticipants(int eventId) async {
    _status = AdminEventStatus.loading;
    _participants = []; // Limpiar lista anterior
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

  // --- POST: Crear Evento (Ya lo tienes, lo mantengo aquí para contexto) ---
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

      // Recargar la lista de eventos para que aparezca el nuevo
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
}