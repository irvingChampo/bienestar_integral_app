import 'package:bienestar_integral_app/features/account_status/domain/entities/transaction.dart';

class TransactionModel extends Transaction {
  TransactionModel({
    required super.id,
    required super.monto,
    required super.donador,
    required super.concepto,
    required super.estado,
    required super.fecha,
    required super.tipo,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    final donorJson = json['donador'] ?? {};

    return TransactionModel(
      id: json['id']?.toString() ?? '',
      monto: json['monto']?.toString() ?? '0.00',

      donador: Donor(
        names: donorJson['names'] ?? 'Anónimo',
        firstLastName: donorJson['firstLastName'] ?? '',
        secondLastName: donorJson['secondLastName'] ?? '',
        email: donorJson['email'] ?? '',
        phoneNumber: donorJson['phoneNumber']?.toString() ?? '',
      ),
      concepto: json['concepto'] ?? 'Sin concepto',
      estado: json['estado'] ?? 'Desconocido',
      fecha: json['fecha'] ?? '',
      tipo: json['tipo'] ?? 'Transacción',
    );
  }
}