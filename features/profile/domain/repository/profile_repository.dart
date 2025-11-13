import 'package:bienestar_integral_app/features/profile/domain/entities/user_profile.dart';

abstract class ProfileRepository {
  Future<UserProfile> getProfile();
  Future<void> updateProfile(Map<String, dynamic> userData);
  Future<void> addUserSkill(int skillId);
  Future<void> removeUserSkill(int skillId);

  // --- MÉTODO `getAvailability` ELIMINADO ---

  Future<void> createAvailabilitySlot(Map<String, dynamic> slotData);
  Future<void> updateAvailabilitySlot(String dayOfWeek, Map<String, dynamic> slotData);
  Future<void> removeAvailabilitySlot(String dayOfWeek);
}