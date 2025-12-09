import 'package:bienestar_integral_app/features/register/domain/entities/municipality.dart';
import 'package:bienestar_integral_app/features/register/domain/repository/register_repository.dart';

class GetMunicipalities {
  final RegisterRepository repository;

  GetMunicipalities(this.repository);

  Future<List<Municipality>> call(String stateId) async {
    return await repository.getMunicipalities(stateId);
  }
}