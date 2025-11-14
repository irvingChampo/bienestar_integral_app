// features/auth/data/repository/auth_repository_impl.dart (ACTUALIZADO)

import 'package:bienestar_integral_app/core/error/exception.dart';
import 'package:bienestar_integral_app/features/auth/data/datasource/auth_datasource.dart';
import 'package:bienestar_integral_app/features/auth/domain/entities/auth_response.dart';
import 'package:bienestar_integral_app/features/auth/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDatasource datasource;

  AuthRepositoryImpl({required this.datasource});

  @override
  Future<AuthResponse> login(String email, String password) async {
    try {
      // El repositorio simplemente llama al datasource.
      final authResponseModel = await datasource.login(email, password);
      return authResponseModel;
    } catch (e) {
      // --- CAMBIO: Se re-lanza la excepción original sin modificarla ---
      // Esto permite que el provider reciba la excepción específica
      // (ej. InvalidCredentialsException) y actúe en consecuencia.
      rethrow;
    }
  }
}