import 'package:bienestar_integral_app/features/home/data/datasource/kitchen_datasource.dart';
import 'package:bienestar_integral_app/features/home/domain/entities/kitchen.dart';
import 'package:bienestar_integral_app/features/home/domain/entities/kitchen_detail.dart';
import 'package:bienestar_integral_app/features/home/domain/entities/kitchen_subscription.dart';
import 'package:bienestar_integral_app/features/home/domain/repository/kitchen_repository.dart';
// ... imports

class KitchenRepositoryImpl implements KitchenRepository {
  final KitchenDatasource datasource;
  KitchenRepositoryImpl({required this.datasource});

  // ... (otros métodos) ...

  @override
  Future<List<Schedule>> getKitchenSchedules(int kitchenId) async {
    return await datasource.getKitchenSchedules(kitchenId);
  }

  // ... (asegúrate que estén todos los demás métodos implementados)
  @override
  Future<KitchenDetail> getMyKitchen() async => await datasource.getMyKitchen();
  @override
  Future<List<Kitchen>> getNearbyKitchens() async => await datasource.getNearbyKitchens();
  @override
  Future<KitchenDetail> getKitchenDetails(int kitchenId) async => await datasource.getKitchenDetails(kitchenId);
  @override
  Future<void> subscribeToKitchen(int kitchenId) async => await datasource.subscribeToKitchen(kitchenId);
  @override
  Future<void> unsubscribeFromKitchen(int kitchenId) async => await datasource.unsubscribeFromKitchen(kitchenId);
  @override
  Future<List<int>> getSubscribedKitchenIds() async => await datasource.getSubscribedKitchenIds();
  @override
  Future<List<KitchenSubscription>> getMyKitchenSubscriptions() async => await datasource.getMyKitchenSubscriptions();
}