import 'package:bienestar_integral_app/features/register/domain/entities/state.dart';
import 'package:bienestar_integral_app/features/register/domain/repository/register_repository.dart';

class GetStates {
  final RegisterRepository repository;

  GetStates(this.repository);

  Future<List<State>> call() async {
    return await repository.getStates();
  }
}