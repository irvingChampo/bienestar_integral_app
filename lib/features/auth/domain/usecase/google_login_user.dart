import 'package:bienestar_integral_app/features/auth/domain/repository/auth_repository.dart';

class GoogleLoginUser {
  final AuthRepository repository;

  GoogleLoginUser(this.repository);

  Future<Map<String, dynamic>> call(String token) async {
    return await repository.googleLogin(token);
  }
}