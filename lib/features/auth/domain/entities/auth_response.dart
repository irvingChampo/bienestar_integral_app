import 'package:bienestar_integral_app/features/auth/domain/entities/user.dart';

class AuthResponse {
  final User user;
  final String accessToken;
  final String refreshToken;
  final List<String> roles;

  AuthResponse({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
    required this.roles,
  });
}