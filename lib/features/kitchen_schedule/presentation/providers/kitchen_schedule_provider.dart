import 'package:bienestar_integral_app/core/error/exception.dart';
import 'package:bienestar_integral_app/features/kitchen_schedule/data/datasource/kitchen_schedule_datasource.dart';
import 'package:bienestar_integral_app/features/kitchen_schedule/data/repository/kitchen_schedule_repository_impl.dart';
import 'package:bienestar_integral_app/features/kitchen_schedule/domain/usecase/create_kitchen_schedules.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

enum ScheduleStatus { initial, loading, success, error }

class KitchenScheduleProvider extends ChangeNotifier {
  late final CreateKitchenSchedules _createKitchenSchedules;

  ScheduleStatus _status = ScheduleStatus.initial;
  String? _errorMessage;

  // Variables para almacenar las horas
  TimeOfDay? weekStart;
  TimeOfDay? weekEnd;
  TimeOfDay? weekendStart;
  TimeOfDay? weekendEnd;

  KitchenScheduleProvider() {
    final datasource = KitchenScheduleDatasourceImpl(client: http.Client());
    final repository = KitchenScheduleRepositoryImpl(datasource: datasource);
    _createKitchenSchedules = CreateKitchenSchedules(repository);
  }

  ScheduleStatus get status => _status;
  String? get errorMessage => _errorMessage;

  void updateTime({
    required bool isWeekend,
    required bool isStart,
    required TimeOfDay time,
  }) {
    if (isWeekend) {
      if (isStart) weekendStart = time; else weekendEnd = time;
    } else {
      if (isStart) weekStart = time; else weekEnd = time;
    }
    notifyListeners();
  }

  // Formatea TimeOfDay a "HH:mm" (ej: 08:00)
  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Future<bool> saveSchedules(int kitchenId) async {
    if (weekStart == null || weekEnd == null || weekendStart == null || weekendEnd == null) {
      _errorMessage = 'Por favor configura todos los horarios.';
      _status = ScheduleStatus.error;
      notifyListeners();
      return false;
    }

    _status = ScheduleStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      await _createKitchenSchedules(
        kitchenId: kitchenId,
        weekStart: _formatTime(weekStart!),
        weekEnd: _formatTime(weekEnd!),
        weekendStart: _formatTime(weekendStart!),
        weekendEnd: _formatTime(weekendEnd!),
      );
      _status = ScheduleStatus.success;
      notifyListeners();
      return true;
    } on ServerException catch (e) {
      _errorMessage = e.message;
      _status = ScheduleStatus.error;
    } on NetworkException catch (e) {
      _errorMessage = e.message;
      _status = ScheduleStatus.error;
    } catch (e) {
      _errorMessage = 'Error inesperado al guardar horarios.';
      _status = ScheduleStatus.error;
    }
    notifyListeners();
    return false;
  }
}