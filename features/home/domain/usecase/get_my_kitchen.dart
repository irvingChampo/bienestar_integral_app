import 'package:bienestar_integral_app/features/home/domain/entities/kitchen_detail.dart';
import 'package:bienestar_integral_app/features/home/domain/repository/kitchen_repository.dart';

class GetMyKitchen {
  final KitchenRepository repository;

  GetMyKitchen(this.repository);

  Future<KitchenDetail> call() async {
    return await repository.getMyKitchen();
  }
}