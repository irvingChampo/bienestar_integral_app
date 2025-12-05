import 'package:bienestar_integral_app/features/home/domain/entities/kitchen.dart';
import 'package:bienestar_integral_app/features/home/domain/entities/kitchen_detail.dart';
import 'package:bienestar_integral_app/features/home/domain/entities/kitchen_subscription.dart'; // <-- IMPORT

abstract class KitchenRepository {
  Future<List<Kitchen>> getNearbyKitchens();
  Future<KitchenDetail> getKitchenDetails(int kitchenId);
  Future<void> subscribeToKitchen(int kitchenId);
  Future<void> unsubscribeFromKitchen(int kitchenId);
  Future<List<int>> getSubscribedKitchenIds();
  // --- NUEVO ---
  Future<List<KitchenSubscription>> getMyKitchenSubscriptions();
}