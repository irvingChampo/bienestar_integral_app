import 'package:bienestar_integral_app/features/register/domain/entities/skill.dart';

class SkillModel extends Skill {
  SkillModel({
    required super.id,
    required super.name,
  });

  factory SkillModel.fromJson(Map<String, dynamic> json) {
    return SkillModel(
      id: json['id'],
      name: json['name'],
    );
  }
}