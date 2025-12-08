import 'package:bienestar_integral_app/features/register/domain/entities/skill.dart';
import 'package:bienestar_integral_app/features/register/domain/repository/register_repository.dart';

class GetSkills {
  final RegisterRepository repository;

  GetSkills(this.repository);

  Future<List<Skill>> call() async {
    return await repository.getSkills();
  }
}