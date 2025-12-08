import 'package:bienestar_integral_app/features/home/domain/repository/kitchen_repository.dart';

class SubscribeToKitchen {
  final KitchenRepository repository;

  SubscribeToKitchen(this.repository);

  Future<void> call(int kitchenId) async {
    await repository.subscribeToKitchen(kitchenId);
  }
}