import 'package:bienestar_integral_app/features/auth/data/models/user_model.dart';
import 'package:bienestar_integral_app/features/auth/domain/entities/auth_response.dart';
class AuthResponseModel extends AuthResponse {
  AuthResponseModel({
    required super.user,
    required super.accessToken,
    required super.refreshToken,
    required super.roles,
  });
  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      user: UserModel.fromJson(json['user']),
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
      roles: List<String>.from(json['roles'].map((x) => x)),
    );
  }
}