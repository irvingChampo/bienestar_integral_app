import 'package:bienestar_integral_app/features/payments/domain/entities/payment_intent.dart';
import 'package:bienestar_integral_app/features/payments/domain/repository/payment_repository.dart';

class CreateDonation {
  final PaymentRepository repository;

  CreateDonation(this.repository);

  Future<PaymentIntent> call({
    required int kitchenId,
    required double amount,
    String? description,
  }) async {
    return await repository.createDonation(
      kitchenId: kitchenId,
      amount: amount,
      description: description,
    );
  }
}