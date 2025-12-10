import 'package:bienestar_integral_app/features/profile/domain/repository/profile_repository.dart';

class DeleteAccount {
  final ProfileRepository repository;

  DeleteAccount(this.repository);

  Future<void> call() async {
    await repository.deleteAccount();
  }
}