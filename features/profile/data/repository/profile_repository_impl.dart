import 'package:bienestar_integral_app/features/profile/data/datasource/profile_datasource.dart';
import 'package:bienestar_integral_app/features/profile/domain/entities/user_profile.dart';
import 'package:bienestar_integral_app/features/profile/domain/repository/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileDatasource datasource;

  ProfileRepositoryImpl({required this.datasource});

  @override
  Future<UserProfile> getProfile() async {
    try {
      return await datasource.getProfile();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateProfile(Map<String, dynamic> userData) async {
    try {
      await datasource.updateProfile(userData);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> addUserSkill(int skillId) async {
    try {
      await datasource.addUserSkill(skillId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> removeUserSkill(int skillId) async {
    try {
      await datasource.removeUserSkill(skillId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> createAvailabilitySlot(Map<String, dynamic> slotData) async {
    try {
      await datasource.createAvailabilitySlot(slotData);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateAvailabilitySlot(String dayOfWeek, Map<String, dynamic> slotData) async {
    try {
      await datasource.updateAvailabilitySlot(dayOfWeek, slotData);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> removeAvailabilitySlot(String dayOfWeek) async {
    try {
      await datasource.removeAvailabilitySlot(dayOfWeek);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> resendEmailVerification() async {
    try {
      await datasource.resendEmailVerification();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> resendPhoneVerification() async {
    try {
      await datasource.resendPhoneVerification();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> verifyPhone(String code) async {
    try {
      await datasource.verifyPhone(code);
    } catch (e) {
      rethrow;
    }
  }

  // (+) Implementación Eliminar Cuenta
  @override
  Future<void> deleteAccount() async {
    try {
      await datasource.deleteAccount();
    } catch (e) {
      rethrow;
    }
  }
}