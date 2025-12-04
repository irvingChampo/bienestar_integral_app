import 'package:bienestar_integral_app/features/profile/domain/repository/profile_repository.dart';

class ResendEmailVerification {
  final ProfileRepository repository;

  ResendEmailVerification(this.repository);

  Future<void> call() async {
    await repository.resendEmailVerification();
  }
}