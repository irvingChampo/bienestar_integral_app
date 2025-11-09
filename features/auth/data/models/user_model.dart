import 'package:bienestar_integral_app/features/auth/domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required super.id,
    required super.email,
    required super.names,
    required super.fullName,
    required super.status,
    required super.verifiedEmail,
    required super.verifiedPhone,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      names: json['names'],
      fullName: json['fullName'],
      status: json['status'],
      verifiedEmail: json['verifiedEmail'],
      verifiedPhone: json['verifiedPhone'],
    );
  }
}