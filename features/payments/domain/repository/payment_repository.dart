import 'package:bienestar_integral_app/features/payments/domain/entities/payment_intent.dart';

abstract class PaymentRepository {
  Future<PaymentIntent> createDonation({
    required int kitchenId,
    required double amount,
    String? description,
  });
}