import 'package:bienestar_integral_app/features/register/domain/entities/state.dart';

class StateModel extends State {
  StateModel({
    required super.id,
    required super.name,
  });

  factory StateModel.fromJson(Map<String, dynamic> json) {
    return StateModel(
      id: json['id'],
      name: json['name'],
    );
  }
}