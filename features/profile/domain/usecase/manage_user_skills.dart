import 'package:bienestar_integral_app/features/profile/domain/repository/profile_repository.dart';

class AddUserSkill {
  final ProfileRepository repository;
  AddUserSkill(this.repository);
  Future<void> call(int skillId) async => await repository.addUserSkill(skillId);
}

class RemoveUserSkill {
  final ProfileRepository repository;
  RemoveUserSkill(this.repository);
  Future<void> call(int skillId) async => await repository.removeUserSkill(skillId);
}