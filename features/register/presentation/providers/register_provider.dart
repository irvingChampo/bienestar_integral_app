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

enum RegisterStatus { initial, loading, success, error }

class RegisterProvider extends ChangeNotifier {
  // Casos de uso
  late final GetStates _getStates;
  late final GetMunicipalities _getMunicipalities;
  late final GetSkills _getSkills;
  late final RegisterUser _registerUser;

  // Estado de la UI
  RegisterStatus _status = RegisterStatus.initial;
  String? _errorMessage;
  List<app.State> _states = [];
  List<Municipality> _municipalities = [];
  List<Skill> _skills = [];

  // Datos del formulario
  Map<String, dynamic> _registrationData = {};

  RegisterProvider() {
    final datasource = RegisterDatasourceImpl(client: http.Client());
    final repository = RegisterRepositoryImpl(datasource: datasource);
    _getStates = GetStates(repository);
    _getMunicipalities = GetMunicipalities(repository);
    _getSkills = GetSkills(repository);
    _registerUser = RegisterUser(repository);

    // Cargar datos iniciales
    loadInitialData();
  }

  // Getters
  RegisterStatus get status => _status;
  String? get errorMessage => _errorMessage;
  List<app.State> get states => _states;
  List<Municipality> get municipalities => _municipalities;
  List<Skill> get skills => _skills;

  // Métodos de carga
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
    _municipalities = []; // Limpiar municipios anteriores
    notifyListeners();
    try {
      _municipalities = await _getMunicipalities(stateId.toString());
    } catch (e) {
      _errorMessage = 'No se pudieron cargar los municipios.';
      notifyListeners();
    }
    notifyListeners();
  }

  // Métodos para el flujo de registro
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
      // Formatear availabilitySlots al formato requerido por la API
      final Map<String, bool> availability = _registrationData['availability'];
      final List<Map<String, String>> slots = [];
      availability.forEach((day, isSelected) {
        if (isSelected) {
          // NOTA: Los tiempos son fijos por ahora, esto debería ser dinámico en una app real.
          slots.add({
            "dayOfWeek": _mapDayToEnglish(day),
            "startTime": "09:00",
            "endTime": "17:00"
          });
        }
      });

      final Map<String, dynamic> finalData = {
        ..._registrationData,
        "availabilitySlots": slots,
      };

      // Eliminar datos que no necesita el endpoint
      finalData.remove('availability');
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

  String _mapDayToEnglish(String dayInitial) {
    switch (dayInitial) {
      case 'L': return 'monday';
      case 'M': return 'tuesday';
      case 'X': return 'wednesday';
      case 'J': return 'thursday';
      case 'V': return 'friday';
      case 'S': return 'saturday';
      case 'D': return 'sunday';
      default: return '';
    }
  }
}