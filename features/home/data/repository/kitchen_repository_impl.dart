// features/home/data/repository/kitchen_repository_impl.dart (MODIFICADO)

import 'package:bienestar_integral_app/features/home/data/datasource/kitchen_datasource.dart';
import 'package:bienestar_integral_app/features/home/domain/entities/kitchen.dart';
import 'package:bienestar_integral_app/features/home/domain/entities/kitchen_detail.dart';
import 'package:bienestar_integral_app/features/home/domain/repository/kitchen_repository.dart';

class KitchenRepositoryImpl implements KitchenRepository {
  final KitchenDatasource datasource;

  KitchenRepositoryImpl({required this.datasource});

  @override
  Future<List<Kitchen>> getNearbyKitchens() async {
    try {
      final kitchenModels = await datasource.getNearbyKitchens();
      return kitchenModels;
    } catch (e) {
      rethrow;
    }
  }

  // --- IMPLEMENTACIÓN DEL NUEVO MÉTODO ---
  @override
  Future<KitchenDetail> getKitchenDetails(int kitchenId) async {
    try {
      final kitchenDetailModel = await datasource.getKitchenDetails(kitchenId);
      return kitchenDetailModel;
    } catch (e) {
      rethrow;
    }
  }
}