import 'package:bienestar_integral_app/features/auth/domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required super.id,
    required super.email,
    required super.names,
    super.firstLastName,
    super.secondLastName,
    super.phoneNumber,
    required super.status,
    required super.verifiedEmail,
    required super.verifiedPhone,
    super.fullName,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      names: json['names'],
      // Estos campos pueden ser nulos, así que no hay problema si no vienen en el JSON
      firstLastName: json['firstLastName'],
      secondLastName: json['secondLastName'],
      phoneNumber: json['phoneNumber'],
      status: json['status'],
      verifiedEmail: json['verifiedEmail'],
      verifiedPhone: json['verifiedPhone'],
      fullName: json['fullName'],
    );
  }
}