import 'package:bienestar_integral_app/features/home/domain/entities/kitchen.dart';

class KitchenSubscription {
  final int membershipId;
  final Kitchen kitchen;

  KitchenSubscription({
    required this.membershipId,
    required this.kitchen,
  });
}