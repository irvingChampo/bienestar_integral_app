class User {
  final int id;
  final String email;
  final String names;
  final String fullName;
  final String status;
  final bool verifiedEmail;
  final bool verifiedPhone;

  User({
    required this.id,
    required this.email,
    required this.names,
    required this.fullName,
    required this.status,
    required this.verifiedEmail,
    required this.verifiedPhone,
  });
}