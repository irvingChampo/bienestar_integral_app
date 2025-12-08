import 'package:bienestar_integral_app/features/home/data/models/kitchen_model.dart';
import 'package:bienestar_integral_app/features/home/domain/entities/kitchen_subscription.dart';

class KitchenSubscriptionModel extends KitchenSubscription {
  KitchenSubscriptionModel({
    required super.membershipId,
    required super.kitchen,
  });

  factory KitchenSubscriptionModel.fromJson(Map<String, dynamic> json) {
    return KitchenSubscriptionModel(
      membershipId: json['membershipId'] ?? 0,
      // Reutilizamos el KitchenModel existente para parsear los datos de la cocina anidada
      kitchen: KitchenModel.fromJson(json['kitchen'] ?? {}),
    );
  }
}