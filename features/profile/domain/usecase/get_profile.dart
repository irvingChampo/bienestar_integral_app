import 'package:bienestar_integral_app/features/profile/domain/entities/user_profile.dart';
import 'package:bienestar_integral_app/features/profile/domain/repository/profile_repository.dart';

class GetProfile {
  final ProfileRepository repository;

  GetProfile(this.repository);

  Future<UserProfile> call() async {
    return await repository.getProfile();
  }
}