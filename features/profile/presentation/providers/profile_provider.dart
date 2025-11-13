import 'package:bienestar_integral_app/core/error/exception.dart';
import 'package:bienestar_integral_app/features/profile/data/datasource/profile_datasource.dart';
import 'package:bienestar_integral_app/features/profile/data/models/user_profile_model.dart';
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
  late final CreateAvailabilitySlot _createAvailabilitySlot;
  late final UpdateAvailabilitySlot _updateAvailabilitySlot;
  late final RemoveAvailabilitySlot _removeAvailabilitySlot;

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
    _createAvailabilitySlot = CreateAvailabilitySlot(repository);
    _updateAvailabilitySlot = UpdateAvailabilitySlot(repository);
    _removeAvailabilitySlot = RemoveAvailabilitySlot(repository);
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

  Future<bool> saveChanges({
    required Map<String, dynamic> basicInfo,
    required List<int> newSkillIds,
    required Map<String, bool> daysSelected,
    required Map<String, TimeOfDay?> startTimes,
    required Map<String, TimeOfDay?> endTimes,
  }) async {
    _status = ProfileStatus.updating;
    _errorMessage = null;
    notifyListeners();

    try {
      if (_didBasicInfoChange(basicInfo)) {
        await _updateProfile(basicInfo);
      }
      await _updateSkills(newSkillIds);
      await _updateAvailability(daysSelected, startTimes, endTimes);

      await fetchProfile();
      return true;

    } on ServerException catch (e) {
      _errorMessage = e.message;
      _status = ProfileStatus.error;
    } on NetworkException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = 'Ocurrió un error inesperado al guardar: $e';
      _status = ProfileStatus.error;
    }
    notifyListeners();
    return false;
  }

  bool _didBasicInfoChange(Map<String, dynamic> newInfo) {
    final user = _userProfile?.user;
    if (user == null) return true;
    return user.names != newInfo['names'] ||
        (user.firstLastName ?? '') != (newInfo['firstLastName'] ?? '') ||
        (user.secondLastName ?? '') != (newInfo['secondLastName'] ?? '') ||
        (user.phoneNumber ?? '') != (newInfo['phoneNumber'] ?? '');
  }

  Future<void> _updateSkills(List<int> newSkillIds) async {
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
  }

  Future<void> _updateAvailability(
      Map<String, bool> daysSelected,
      Map<String, TimeOfDay?> startTimes,
      Map<String, TimeOfDay?> endTimes,
      ) async {
    final originalAvailability = _userProfile?.availability ?? [];
    final timeFormatter = DateFormat('HH:mm');
    List<Future> tasks = [];

    for (String dayInSpanish in daysSelected.keys) {
      final isNowSelected = daysSelected[dayInSpanish] ?? false;
      final dayInEnglish = _mapSpanishDayToEnglish(dayInSpanish);

      final originalSlot = originalAvailability.firstWhere(
            (slot) => slot.dayOfWeek.toLowerCase() == dayInEnglish,
        orElse: () => AvailabilitySlotModel(dayOfWeek: '', startTime: '', endTime: ''),
      );

      final wasOriginallySelected = originalSlot.dayOfWeek.isNotEmpty;

      if (isNowSelected && !wasOriginallySelected) {
        // CREAR nuevo slot - POST /api/v1/availability/me
        debugPrint("Añadiendo disponibilidad para $dayInEnglish con POST");
        final startTime = startTimes[dayInSpanish]!;
        final endTime = endTimes[dayInSpanish]!;
        tasks.add(_createAvailabilitySlot({
          "dayOfWeek": dayInEnglish.toLowerCase(), // CAMBIADO: ahora en minúsculas
          "startTime": timeFormatter.format(DateTime(0, 0, 0, startTime.hour, startTime.minute)),
          "endTime": timeFormatter.format(DateTime(0, 0, 0, endTime.hour, endTime.minute)),
        }));
      } else if (!isNowSelected && wasOriginallySelected) {
        // ELIMINAR slot - DELETE /api/v1/availability/me/{dayOfWeek}
        debugPrint("Eliminando disponibilidad para $dayInEnglish con DELETE");
        tasks.add(_removeAvailabilitySlot(dayInEnglish));
      } else if (isNowSelected && wasOriginallySelected) {
        // ACTUALIZAR slot existente - PUT /api/v1/availability/me/{dayOfWeek}
        final newStartTime = startTimes[dayInSpanish]!;
        final newEndTime = endTimes[dayInSpanish]!;
        final originalStartTime = TimeOfDay(hour: int.parse(originalSlot.startTime.split(':')[0]), minute: int.parse(originalSlot.startTime.split(':')[1]));
        final originalEndTime = TimeOfDay(hour: int.parse(originalSlot.endTime.split(':')[0]), minute: int.parse(originalSlot.endTime.split(':')[1]));

        if (newStartTime != originalStartTime || newEndTime != originalEndTime) {
          debugPrint("Actualizando disponibilidad para $dayInEnglish con PUT");
          tasks.add(_updateAvailabilitySlot(dayInEnglish, {
            // CAMBIADO: el nuevo endpoint solo requiere startTime y endTime
            "startTime": timeFormatter.format(DateTime(0, 0, 0, newStartTime.hour, newStartTime.minute)),
            "endTime": timeFormatter.format(DateTime(0, 0, 0, newEndTime.hour, newEndTime.minute)),
          }));
        }
      }
    }

    if (tasks.isNotEmpty) {
      await Future.wait(tasks);
    }
  }

  String _mapSpanishDayToEnglish(String dayName) {
    switch (dayName) {
      case 'lunes': return 'monday';
      case 'martes': return 'tuesday';
      case 'miércoles': return 'wednesday';
      case 'jueves': return 'thursday';
      case 'viernes': return 'friday';
      case 'sábado': return 'saturday';
      case 'domingo': return 'sunday';
      default: return '';
    }
  }
}