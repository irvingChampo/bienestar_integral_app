import 'package:bienestar_integral_app/core/error/exception.dart';
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
      // Re-lanzar la excepción para que sea manejada por el caso de uso/provider
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
  Future<void> updateAvailability(List<Map<String, String>> slots) async {
    try {
      await datasource.updateAvailability(slots);
    } catch (e) {
      rethrow;
    }
  }
}