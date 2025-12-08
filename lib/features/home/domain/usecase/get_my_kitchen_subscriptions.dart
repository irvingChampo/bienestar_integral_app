import 'package:bienestar_integral_app/features/home/domain/entities/kitchen_subscription.dart';
import 'package:bienestar_integral_app/features/home/domain/repository/kitchen_repository.dart';

class GetMyKitchenSubscriptions {
  final KitchenRepository repository;

  GetMyKitchenSubscriptions(this.repository);

  Future<List<KitchenSubscription>> call() async {
    return await repository.getMyKitchenSubscriptions();
  }
}