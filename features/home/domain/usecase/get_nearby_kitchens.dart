import 'package:bienestar_integral_app/features/home/domain/entities/kitchen.dart';
import 'package:bienestar_integral_app/features/home/domain/repository/kitchen_repository.dart';

class GetNearbyKitchens {
  final KitchenRepository repository;

  GetNearbyKitchens(this.repository);

  Future<List<Kitchen>> call() async {
    return await repository.getNearbyKitchens();
  }
}