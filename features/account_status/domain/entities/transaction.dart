class Donor {
  final String names;
  final String firstLastName;
  final String secondLastName;
  final String email;
  final String phoneNumber;

  Donor({
    required this.names,
    required this.firstLastName,
    required this.secondLastName,
    required this.email,
    required this.phoneNumber,
  });

  String get fullName => '$names $firstLastName $secondLastName'.trim();
}

class Transaction {
  final String id;
  final String monto; // String formateado del JSON "$500.00 MXN"
  final Donor donador;
  final String concepto;
  final String estado;
  final String fecha;
  final String tipo;

  Transaction({
    required this.id,
    required this.monto,
    required this.donador,
    required this.concepto,
    required this.estado,
    required this.fecha,
    required this.tipo,
  });
}