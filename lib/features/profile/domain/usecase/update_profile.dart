import 'package:bienestar_integral_app/features/profile/domain/repository/profile_repository.dart';

class UpdateProfile {
  final ProfileRepository repository;

  UpdateProfile(this.repository);

  Future<void> call(Map<String, dynamic> userData) async {
    await repository.updateProfile(userData);
  }
}