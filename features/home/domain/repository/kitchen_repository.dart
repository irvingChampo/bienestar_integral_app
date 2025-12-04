// features/home/domain/repository/kitchen_repository.dart (MODIFICADO)

import 'package:bienestar_integral_app/features/home/domain/entities/kitchen.dart';
import 'package:bienestar_integral_app/features/home/domain/entities/kitchen_detail.dart';

abstract class KitchenRepository {
  Future<List<Kitchen>> getNearbyKitchens();
  Future<KitchenDetail> getKitchenDetails(int kitchenId); // <-- MÉTODO AÑADIDO
}