import 'package:bienestar_integral_app/features/auth/domain/entities/auth_response.dart';

abstract class AuthRepository {
  Future<AuthResponse> login(String email, String password);
}