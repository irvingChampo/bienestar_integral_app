import 'package:bienestar_integral_app/core/error/exception.dart';
import 'package:bienestar_integral_app/features/auth/domain/entities/user.dart';
import 'package:bienestar_integral_app/features/profile/data/datasource/profile_datasource.dart';
import 'package:bienestar_integral_app/features/profile/data/models/user_profile_model.dart';
import 'package:bienestar_integral_app/features/profile/data/repository/profile_repository_impl.dart';
import 'package:bienestar_integral_app/features/profile/domain/entities/user_profile.dart';
import 'package:bienestar_integral_app/features/profile/domain/usecase/delete_account.dart'; // (+) Importar
import 'package:bienestar_integral_app/features/profile/domain/usecase/get_profile.dart';
import 'package:bienestar_integral_app/features/profile/domain/usecase/manage_user_skills.dart';
import 'package:bienestar_integral_app/features/profile/domain/usecase/resend_email_verification.dart';
import 'package:bienestar_integral_app/features/profile/domain/usecase/resend_phone_verification.dart';
import 'package:bienestar_integral_app/features/profile/domain/usecase/update_availability.dart';
import 'package:bienestar_integral_app/features/profile/domain/usecase/update_profile.dart';
import 'package:bienestar_integral_app/features/profile/domain/usecase/verify_phone.dart';
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

  late final ResendEmailVerification _resendEmailVerification;
  late final ResendPhoneVerification _resendPhoneVerification;
  late final VerifyPhone _verifyPhone;

  // (+) NUEVO CASO DE USO
  late final DeleteAccount _deleteAccount;

  ProfileStatus _status = ProfileStatus.initial;
  String? _errorMessage;
  UserProfile? _userProfile;

  bool _isVerificationLoading = false;
  bool get isVerificationLoading => _isVerificationLoading;

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

    _resendEmailVerification = ResendEmailVerification(repository);
    _resendPhoneVerification = ResendPhoneVerification(repository);
    _verifyPhone = VerifyPhone(repository);

    // (+) Inicializar
    _deleteAccount = DeleteAccount(repository);
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
        final startTime = startTimes[dayInSpanish]!;
        final endTime = endTimes[dayInSpanish]!;
        tasks.add(_createAvailabilitySlot({
          "dayOfWeek": dayInEnglish.toLowerCase(),
          "startTime": timeFormatter.format(DateTime(0, 0, 0, startTime.hour, startTime.minute)),
          "endTime": timeFormatter.format(DateTime(0, 0, 0, endTime.hour, endTime.minute)),
        }));
      } else if (!isNowSelected && wasOriginallySelected) {
        tasks.add(_removeAvailabilitySlot(dayInEnglish));
      } else if (isNowSelected && wasOriginallySelected) {
        final newStartTime = startTimes[dayInSpanish]!;
        final newEndTime = endTimes[dayInSpanish]!;
        final originalStartTime = TimeOfDay(hour: int.parse(originalSlot.startTime.split(':')[0]), minute: int.parse(originalSlot.startTime.split(':')[1]));
        final originalEndTime = TimeOfDay(hour: int.parse(originalSlot.endTime.split(':')[0]), minute: int.parse(originalSlot.endTime.split(':')[1]));

        if (newStartTime != originalStartTime || newEndTime != originalEndTime) {
          tasks.add(_updateAvailabilitySlot(dayInEnglish, {
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

  Future<bool> sendEmailVerification() async {
    _isVerificationLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _resendEmailVerification();
      return true;
    } on ServerException catch (e) {
      _errorMessage = e.message;
    } on NetworkException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = 'Error inesperado al enviar correo.';
    } finally {
      _isVerificationLoading = false;
      notifyListeners();
    }
    return false;
  }

  Future<bool> sendPhoneVerification() async {
    _isVerificationLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _resendPhoneVerification();
      return true;
    } on ServerException catch (e) {
      _errorMessage = e.message;
    } on NetworkException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = 'Error inesperado al enviar SMS.';
    } finally {
      _isVerificationLoading = false;
      notifyListeners();
    }
    return false;
  }

  Future<bool> verifyPhoneCode(String code) async {
    _isVerificationLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _verifyPhone(code);
      _markPhoneAsVerified();
      return true;
    } on ServerException catch (e) {
      _errorMessage = e.message;
    } on NetworkException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = 'Error inesperado al verificar código.';
    } finally {
      _isVerificationLoading = false;
      notifyListeners();
    }
    return false;
  }

  void _markPhoneAsVerified() {
    if (_userProfile == null) return;
    final currentUser = _userProfile!.user;

    final updatedUser = User(
      id: currentUser.id,
      email: currentUser.email,
      names: currentUser.names,
      firstLastName: currentUser.firstLastName,
      secondLastName: currentUser.secondLastName,
      phoneNumber: currentUser.phoneNumber,
      status: currentUser.status,
      verifiedEmail: currentUser.verifiedEmail,
      verifiedPhone: true,
      fullName: currentUser.fullName,
    );

    _userProfile = UserProfile(
      user: updatedUser,
      skills: _userProfile!.skills,
      availability: _userProfile!.availability,
    );
    notifyListeners();
  }

  // (+) Método público para eliminar cuenta
  Future<bool> deleteUserAccount() async {
    _status = ProfileStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      await _deleteAccount();
      _status = ProfileStatus.success;
      return true;
    } on ServerException catch (e) {
      _errorMessage = e.message;
      _status = ProfileStatus.error;
    } on NetworkException catch (e) {
      _errorMessage = e.message;
      _status = ProfileStatus.error;
    } catch (e) {
      _errorMessage = 'Error inesperado al eliminar la cuenta.';
      _status = ProfileStatus.error;
    }

    // Si hubo error, quitamos el loading. Si es éxito, SettingsScreen hará el logout.
    if (_status == ProfileStatus.error) {
      notifyListeners();
    }

    return false;
  }
}