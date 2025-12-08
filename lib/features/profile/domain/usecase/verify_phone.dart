import 'package:bienestar_integral_app/features/profile/domain/repository/profile_repository.dart';

class VerifyPhone {
  final ProfileRepository repository;

  VerifyPhone(this.repository);

  Future<void> call(String code) async {
    await repository.verifyPhone(code);
  }
}