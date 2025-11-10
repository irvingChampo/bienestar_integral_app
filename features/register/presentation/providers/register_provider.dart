import 'package:bienestar_integral_app/core/error/exception.dart';
import 'package:bienestar_integral_app/features/register/data/datasource/register_datasource.dart';
import 'package:bienestar_integral_app/features/register/data/repository/register_repository_impl.dart';
import 'package:bienestar_integral_app/features/register/domain/entities/municipality.dart';
import 'package:bienestar_integral_app/features/register/domain/entities/skill.dart';
import 'package:bienestar_integral_app/features/register/domain/entities/state.dart' as app;
import 'package:bienestar_integral_app/features/register/domain/usecase/get_municipalities.dart';
import 'package:bienestar_integral_app/features/register/domain/usecase/get_skills.dart';
import 'package:bienestar_integral_app/features/register/domain/usecase/get_states.dart';
import 'package:bienestar_integral_app/features/register/domain/usecase/register_user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; // Necesario para formatear la hora

enum RegisterStatus { initial, loading, success, error }

class RegisterProvider extends ChangeNotifier {
  late final GetStates _getStates;
  late final GetMunicipalities _getMunicipalities;
  late final GetSkills _getSkills;
  late final RegisterUser _registerUser;

  RegisterStatus _status = RegisterStatus.initial;
  String? _errorMessage;
  List<app.State> _states = [];
  List<Municipality> _municipalities = [];
  List<Skill> _skills = [];
  Map<String, dynamic> _registrationData = {};

  RegisterProvider() {
    final datasource = RegisterDatasourceImpl(client: http.Client());
    final repository = RegisterRepositoryImpl(datasource: datasource);
    _getStates = GetStates(repository);
    _getMunicipalities = GetMunicipalities(repository);
    _getSkills = GetSkills(repository);
    _registerUser = RegisterUser(repository);
    loadInitialData();
  }

  RegisterStatus get status => _status;
  String? get errorMessage => _errorMessage;
  List<app.State> get states => _states;
  List<Municipality> get municipalities => _municipalities;
  List<Skill> get skills => _skills;

  Future<void> loadInitialData() async {
    _status = RegisterStatus.loading;
    notifyListeners();
    try {
      _states = await _getStates();
      _skills = await _getSkills();
      _status = RegisterStatus.initial;
    } catch (e) {
      _errorMessage = 'No se pudieron cargar los datos iniciales.';
      _status = RegisterStatus.error;
    }
    notifyListeners();
  }

  Future<void> fetchMunicipalities(int stateId) async {
    _municipalities = [];
    notifyListeners();
    try {
      _municipalities = await _getMunicipalities(stateId.toString());
    } catch (e) {
      _errorMessage = 'No se pudieron cargar los municipios.';
    }
    notifyListeners();
  }

  void saveStep1Data(Map<String, dynamic> data) {
    _registrationData.addAll(data);
  }

  void saveStep3Data(Map<String, dynamic> data) {
    _registrationData.addAll(data);
  }

  Future<void> submitRegistration() async {
    _status = RegisterStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      // --- LÓGICA DE HORARIOS ACTUALIZADA ---
      final Map<String, bool> availability = _registrationData['availability'];
      final Map<String, TimeOfDay?> startTimes = _registrationData['startTimes'];
      final Map<String, TimeOfDay?> endTimes = _registrationData['endTimes'];

      final List<Map<String, String>> slots = [];
      final timeFormatter = DateFormat('HH:mm'); // Formato 24h para la API

      availability.forEach((dayName, isSelected) {
        if (isSelected) {
          final startTime = startTimes[dayName];
          final endTime = endTimes[dayName];
          if (startTime != null && endTime != null) {
            slots.add({
              "dayOfWeek": _mapDayToEnglish(dayName),
              "startTime": timeFormatter.format(DateTime(2023, 1, 1, startTime.hour, startTime.minute)),
              "endTime": timeFormatter.format(DateTime(2023, 1, 1, endTime.hour, endTime.minute)),
            });
          }
        }
      });
      // --- FIN DE LA LÓGICA ACTUALIZADA ---

      final Map<String, dynamic> finalData = {
        ..._registrationData,
        "availabilitySlots": slots,
      };

      finalData.remove('availability');
      finalData.remove('startTimes');
      finalData.remove('endTimes');
      finalData.remove('confirmPassword');

      await _registerUser(finalData);
      _status = RegisterStatus.success;

    } on ServerException catch (e) {
      _errorMessage = e.message;
      _status = RegisterStatus.error;
    } on NetworkException catch (e) {
      _errorMessage = e.message;
      _status = RegisterStatus.error;
    } catch (e) {
      _errorMessage = 'Ocurrió un error inesperado.';
      _status = RegisterStatus.error;
    }
    notifyListeners();
  }

  String _mapDayToEnglish(String dayName) {
    return dayName.toLowerCase().replaceAll('é', 'e').replaceAll('á', 'a');
  }
}