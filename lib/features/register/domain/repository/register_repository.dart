import 'package:bienestar_integral_app/features/register/domain/entities/municipality.dart';
import 'package:bienestar_integral_app/features/register/domain/entities/skill.dart';
import 'package:bienestar_integral_app/features/register/domain/entities/state.dart';

abstract class RegisterRepository {
  Future<List<State>> getStates();
  Future<List<Municipality>> getMunicipalities(String stateId);
  Future<List<Skill>> getSkills();
  Future<void> registerUser(Map<String, dynamic> userData);
}