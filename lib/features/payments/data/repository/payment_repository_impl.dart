import 'package:bienestar_integral_app/features/payments/data/datasource/payment_datasource.dart';
import 'package:bienestar_integral_app/features/payments/domain/entities/payment_intent.dart';
import 'package:bienestar_integral_app/features/payments/domain/repository/payment_repository.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentDatasource datasource;

  PaymentRepositoryImpl({required this.datasource});

  @override
  Future<PaymentIntent> createDonation({
    required int kitchenId,
    required double amount,
    String? description,
  }) async {
    try {
      return await datasource.createPaymentIntent(
        kitchenId: kitchenId,
        amount: amount,
        description: description,
      );
    } catch (e) {
      rethrow;
    }
  }
}