import 'package:bienestar_integral_app/features/profile/domain/entities/user_profile.dart';

abstract class ProfileRepository {
  Future<UserProfile> getProfile();
  Future<void> updateProfile(Map<String, dynamic> userData);
  Future<void> addUserSkill(int skillId);
  Future<void> removeUserSkill(int skillId);
  Future<void> updateAvailability(List<Map<String, String>> slots);
}