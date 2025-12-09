class EventParticipant {
  final int id;
  final int userId;
  final String registrationType;
  final bool attended;
  final String names;
  final String? firstLastName;
  final String email;
  final String? phoneNumber;

  EventParticipant({
    required this.id,
    required this.userId,
    required this.registrationType,
    required this.attended,
    required this.names,
    this.firstLastName,
    required this.email,
    this.phoneNumber,
  });

  String get fullName => '$names ${firstLastName ?? ''}'.trim();
}