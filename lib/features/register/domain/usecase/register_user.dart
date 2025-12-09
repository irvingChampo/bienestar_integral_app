import 'package:bienestar_integral_app/features/register/domain/repository/register_repository.dart';

class RegisterUser {
  final RegisterRepository repository;

  RegisterUser(this.repository);

  Future<void> call(Map<String, dynamic> userData) async {
    await repository.registerUser(userData);
  }
}