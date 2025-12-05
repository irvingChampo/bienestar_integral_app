import 'package:bienestar_integral_app/features/home/domain/repository/kitchen_repository.dart';

class UnsubscribeFromKitchen {
  final KitchenRepository repository;

  UnsubscribeFromKitchen(this.repository);

  Future<void> call(int kitchenId) async {
    await repository.unsubscribeFromKitchen(kitchenId);
  }
}