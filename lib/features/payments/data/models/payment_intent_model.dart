import 'package:bienestar_integral_app/features/payments/domain/entities/payment_intent.dart';

class PaymentIntentModel extends PaymentIntent {
  PaymentIntentModel({
    required super.paymentUrl,
  });

  factory PaymentIntentModel.fromJson(Map<String, dynamic> json) {
    return PaymentIntentModel(
      // Según el JSON proporcionado, la URL viene dentro de data: { url: "..." }
      // El datasource extraerá 'data', así que aquí leemos 'url'.
      paymentUrl: json['url'] ?? '',
    );
  }
}