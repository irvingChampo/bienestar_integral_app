import 'package:bienestar_integral_app/features/profile/domain/repository/profile_repository.dart';

class UpdateAvailability {
  final ProfileRepository repository;

  UpdateAvailability(this.repository);

  Future<void> call(List<Map<String, String>> slots) async {
    await repository.updateAvailability(slots);
  }
}