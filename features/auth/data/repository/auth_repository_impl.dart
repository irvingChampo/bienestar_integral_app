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
      final authResponseModel = await datasource.login(email, password);
      // El modelo es compatible con la entidad, así que podemos retornarlo directamente.
      return authResponseModel;
    } on ServerException catch (e) {
      throw ServerException('Error del servidor: ${e.message}');
    } on NetworkException catch(e) {
      throw NetworkException('Error de red: ${e.message}');
    } catch (e) {
      throw Exception('Ocurrió un error inesperado: $e');
    }
  }
}