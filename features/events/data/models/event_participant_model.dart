import 'package:bienestar_integral_app/features/events/domain/entities/event_participant.dart';

class EventParticipantModel extends EventParticipant {
  EventParticipantModel({
    required super.id,
    required super.userId,
    required super.registrationType,
    required super.attended,
    required super.names,
    super.firstLastName,
    required super.email,
    super.phoneNumber,
  });

  factory EventParticipantModel.fromJson(Map<String, dynamic> json) {
    // Extraemos el objeto 'user' anidado según tu JSON
    final user = json['user'] ?? {};

    return EventParticipantModel(
      id: json['id'] ?? 0,
      userId: json['userId'] ?? 0,
      registrationType: json['registrationType'] ?? 'volunteer',
      attended: json['attended'] ?? false,

      // Mapeamos los datos que están DENTRO del objeto 'user'
      names: user['names'] ?? 'Usuario',
      firstLastName: user['firstLastName'], // Puede ser null
      email: user['email'] ?? '',
      phoneNumber: user['phoneNumber'], // Puede ser null
    );
  }
}