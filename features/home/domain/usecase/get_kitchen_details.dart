// features/home/domain/usecase/get_kitchen_details.dart (NUEVO)

import 'package:bienestar_integral_app/features/home/domain/entities/kitchen_detail.dart';
import 'package:bienestar_integral_app/features/home/domain/repository/kitchen_repository.dart';

class GetKitchenDetails {
  final KitchenRepository repository;

  GetKitchenDetails(this.repository);

  Future<KitchenDetail> call(int kitchenId) async {
    return await repository.getKitchenDetails(kitchenId);
  }
}