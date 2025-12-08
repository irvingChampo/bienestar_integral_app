import 'package:bienestar_integral_app/core/error/exception.dart';
import 'package:bienestar_integral_app/features/register/data/datasource/register_datasource.dart';
import 'package:bienestar_integral_app/features/register/domain/entities/municipality.dart';
import 'package:bienestar_integral_app/features/register/domain/entities/skill.dart';
import 'package:bienestar_integral_app/features/register/domain/entities/state.dart';
import 'package:bienestar_integral_app/features/register/domain/repository/register_repository.dart';

class RegisterRepositoryImpl implements RegisterRepository {
  final RegisterDatasource datasource;

  RegisterRepositoryImpl({required this.datasource});

  @override
  Future<List<State>> getStates() async {
    return await datasource.getStates();
  }

  @override
  Future<List<Municipality>> getMunicipalities(String stateId) async {
    return await datasource.getMunicipalities(stateId);
  }

  @override
  Future<List<Skill>> getSkills() async {
    return await datasource.getSkills();
  }

  @override
  Future<void> registerUser(Map<String, dynamic> userData) async {
    try {
      await datasource.registerUser(userData);
    } catch (e) {
      rethrow;
    }
  }
}