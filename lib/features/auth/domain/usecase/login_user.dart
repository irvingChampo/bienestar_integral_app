import 'package:bienestar_integral_app/features/auth/domain/entities/auth_response.dart';
import 'package:bienestar_integral_app/features/auth/domain/repository/auth_repository.dart';

class LoginUser {
  final AuthRepository repository;

  LoginUser(this.repository);

  Future<AuthResponse> call(String email, String password) async {
    return await repository.login(email, password);
  }
}