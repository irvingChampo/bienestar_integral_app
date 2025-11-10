import 'package:bienestar_integral_app/core/error/exception.dart';
import 'package:bienestar_integral_app/features/profile/data/datasource/profile_datasource.dart';
import 'package:bienestar_integral_app/features/profile/data/repository/profile_repository_impl.dart';
import 'package:bienestar_integral_app/features/profile/domain/entities/user_profile.dart';
import 'package:bienestar_integral_app/features/profile/domain/usecase/get_profile.dart';
import 'package:bienestar_integral_app/features/profile/domain/usecase/manage_user_skills.dart';
import 'package:bienestar_integral_app/features/profile/domain/usecase/update_availability.dart';
import 'package:bienestar_integral_app/features/profile/domain/usecase/update_profile.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

enum ProfileStatus { initial, loading, success, error, updating }

class ProfileProvider extends ChangeNotifier {
  late final GetProfile _getProfile;
  late final UpdateProfile _updateProfile;
  late final AddUserSkill _addUserSkill;
  late final RemoveUserSkill _removeUserSkill;
  late final UpdateAvailability _updateAvailability;

  ProfileStatus _status = ProfileStatus.initial;
  String? _errorMessage;
  UserProfile? _userProfile;

  ProfileProvider() {
    final datasource = ProfileDatasourceImpl(client: http.Client());
    final repository = ProfileRepositoryImpl(datasource: datasource);
    _getProfile = GetProfile(repository);
    _updateProfile = UpdateProfile(repository);
    _addUserSkill = AddUserSkill(repository);
    _removeUserSkill = RemoveUserSkill(repository);
    _updateAvailability = UpdateAvailability(repository);
  }

  ProfileStatus get status => _status;
  String? get errorMessage => _errorMessage;
  UserProfile? get userProfile => _userProfile;

  Future<void> fetchProfile() async {
    _status = ProfileStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _userProfile = await _getProfile();
      _status = ProfileStatus.success;
    } catch (e) {
      _errorMessage = 'No se pudo cargar tu perfil. Inténtalo de nuevo.';
      _status = ProfileStatus.error;
    }
    notifyListeners();
  }

  // --- MÉTODO `saveChanges` COMPLETAMENTE REFACTORIZADO ---
  Future<bool> saveChanges({
    required Map<String, dynamic> basicInfo,
    required List<int> newSkillIds,
    required List<Map<String, String>> newAvailability,
  }) async {
    _status = ProfileStatus.updating;
    _errorMessage = null;
    notifyListeners();

    try {
      // 1. Comparar y actualizar perfil básico si es necesario
      if (_didBasicInfoChange(basicInfo)) {
        debugPrint("Actualizando información básica del perfil...");
        await _updateProfile(basicInfo);
      }

      // 2. Comparar y actualizar skills si es necesario
      final originalSkillIds = _userProfile?.skills.map((s) => s.id).toSet() ?? {};
      final newSkillIdsSet = newSkillIds.toSet();

      if (!setEquals(originalSkillIds, newSkillIdsSet)) {
        debugPrint("Actualizando habilidades...");
        final skillsToAdd = newSkillIdsSet.difference(originalSkillIds);
        final skillsToRemove = originalSkillIds.difference(newSkillIdsSet);

        await Future.wait([
          for (final skillId in skillsToAdd) _addUserSkill(skillId),
          for (final skillId in skillsToRemove) _removeUserSkill(skillId),
        ]);
      }

      // 3. Comparar y actualizar disponibilidad si es necesario
      if (_didAvailabilityChange(newAvailability)) {
        debugPrint("Actualizando disponibilidad...");
        await _updateAvailability(newAvailability);
      }

      await fetchProfile(); // Recargar el perfil para tener los datos más frescos
      return true;

    } on ServerException catch (e) {
      _errorMessage = e.message;
      _status = ProfileStatus.error;
    } on NetworkException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = 'Ocurrió un error inesperado al guardar.';
      _status = ProfileStatus.error;
    }
    notifyListeners();
    return false;
  }

  // --- HELPERS PARA DETECTAR CAMBIOS ---
  bool _didBasicInfoChange(Map<String, dynamic> newInfo) {
    final user = _userProfile?.user;
    if (user == null) return true; // Si no hay datos originales, asumimos que cambió
    return user.names != newInfo['names'] ||
        user.firstLastName != newInfo['firstLastName'] ||
        (user.secondLastName ?? '') != (newInfo['secondLastName'] ?? '') ||
        user.phoneNumber != newInfo['phoneNumber'];
  }

  bool _didAvailabilityChange(List<Map<String, String>> newAvailability) {
    final originalAvailability = _userProfile?.availability ?? [];
    if (originalAvailability.length != newAvailability.length) return true;

    // Convertir a sets de mapas para comparar sin importar el orden
    final originalSet = originalAvailability.map((s) => s.toString()).toSet();
    final newSet = newAvailability.map((s) => s.toString()).toSet();

    return !setEquals(originalSet, newSet);
  }
}