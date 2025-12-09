import 'package:bienestar_integral_app/features/home/domain/entities/kitchen_detail.dart';
import 'package:bienestar_integral_app/features/home/domain/repository/kitchen_repository.dart';

class GetKitchenSchedules {
  final KitchenRepository repository;

  GetKitchenSchedules(this.repository);

  Future<List<Schedule>> call(int kitchenId) async {
    return await repository.getKitchenSchedules(kitchenId);
  }
}