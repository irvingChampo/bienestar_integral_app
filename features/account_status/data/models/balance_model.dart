import 'package:bienestar_integral_app/features/account_status/domain/entities/balance.dart';

class BalanceModel extends Balance {
  BalanceModel({
    required super.available,
    required super.pending,
    required super.currency,
  });

  factory BalanceModel.fromJson(Map<String, dynamic> json) {
    return BalanceModel(
      available: (json['available'] as num?)?.toDouble() ?? 0.0,
      pending: (json['pending'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency'] ?? 'mxn',
    );
  }
}