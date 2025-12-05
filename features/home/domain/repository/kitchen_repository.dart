import 'package:bienestar_integral_app/features/home/domain/entities/kitchen.dart';
import 'package:bienestar_integral_app/features/home/domain/entities/kitchen_detail.dart';

abstract class KitchenRepository {
  Future<List<Kitchen>> getNearbyKitchens();
  Future<KitchenDetail> getKitchenDetails(int kitchenId);
  Future<void> subscribeToKitchen(int kitchenId); // <-- NUEVO
}