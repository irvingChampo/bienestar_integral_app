import 'package:bienestar_integral_app/features/profile/domain/repository/profile_repository.dart';

class ResendPhoneVerification {
  final ProfileRepository repository;

  ResendPhoneVerification(this.repository);

  Future<void> call() async {
    await repository.resendPhoneVerification();
  }
}